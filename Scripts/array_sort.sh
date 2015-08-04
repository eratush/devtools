#!/bin/bash

array=(1 2 3 4 5 6 7 8 1 10 11 12 13 14 15 16 17 18 19 20)

echo "Total elements: ${#array[@]}"

count=${#array[@]}

j=1;
i=0;

while [[ "$i" -lt "$count" ]]; do
   cur_value=${array[$i]}
   j=$((i+1))
   while [[ "$j" -lt "$count" ]]; do
      next_value=${array[$j]}
      if [ "$cur_value" == "$next_value" ]; then
         counter=$((counter+1))
      fi
      j=$((j+1))
   done
   i=$((i+1));
   j=0;
done

echo "Total same elements: $counter"

exit 0
