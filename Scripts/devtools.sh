#!/bin/bash
##
#       devtool.sh
#       Command-line tool for extracting packages from SVN
#       Author: Evgeniy Ratush
#       Version 1.0
##

SERVER_NAME="svn.egartech.com.ua"
PROTO="svn"
USER="eratush"
PASS="123456"
REPO_NAME="ebs_pib"
DEV_NAME=$2
BUILD=$3
HOME_DIR=$HOME

function contains()
{
   if [ -n $1 ] && [ -n $2 ]; then
      local value
      for value in "${@:1}"; do [[ "$value" == "$2" ]] && return 1; done
      return 0
   fi
}

if [ ! -d "$HOME_DIR/DEVS" ]; then
   mkdir $HOME_DIR/DEVS
fi

read -p "Input module name and press [ENTER] (example 'mm0401'): " MNAME

PRODUCT_NAME=${MNAME:0:2}

echo -e "List of avaible modules:\n"

MODULES=`svn list $PROTO://$SERVER_NAME/$REPO_NAME/$PRODUCT_NAME | grep "$MNAME*"`
MODULES=($MODULES)
MCOUNT=${#MODULES[@]}

echo -e "Records count: $MCOUNT\n"
echo ${MODULES[@]}

if [ $MCOUNT -ge 1 ]; then
   read -p "Enter module name from above list and press [ENTER]: " MNAME

   contains "${MODULES[@]}" "$MNAME"

   if [ $? -eq 1 ]; then
      read -p "Checkout module $MNAME? (Y\n):" CHOISE

      if [ $CHOISE == 'Y' ] || [ $CHOISE == 'y' ]; then
         MODULE_DIR_NAME=`echo $MNAME | tr ' ' '_' | tr -d '/'`
         MNAME=${MNAME// /%20}
         svn checkout --force $PROTO://$SERVER_NAME/$REPO_NAME/$PRODUCT_NAME/$MNAME/trunk &>last_checkout.log $HOME_DIR/DEVS/$MODULE_DIR_NAME
         echo -e "\n"
         rm -rf $HOME_DIR/DEVS/$MODULE_DIR_NAME/.svn
         cd $HOME_DIR/DEVS

         OLD_ARCHIVE="$MODULE_DIR_NAME.zip"

         if [ -a $OLD_ARCHIVE ]; then
            rm -rf $OLD_ARCHIVE
         fi
         cd $MODULE_DIR_NAME
         zip -qr ../$MODULE_DIR_NAME.zip *
         rm -rf ../$MODULE_DIR_NAME

         if [ -a ../$MODULE_DIR_NAME.zip ]; then
                echo "Archive $MODULE_DIR_NAME.zip successfully created!"
         else   echo "Archive creatinon error!"
         fi

         echo "Done."
      else
         exit 0
      fi
   fi
else
   echo "No matches found in SVN!"
fi