#!/bin/bash

input_file=$1
output_file=$2
increments=$3
n_steps=$4
original=$( tail -n 1 "$input_file" )
first=$(echo $original | cut -d" " -f 1)
second=$(echo $original | cut -d" " -f 2)
third=$(echo $original | cut -d" " -f 3)
fourth=$(echo $original | cut -d" " -f 4)
fifth=$(echo $original | cut -d" " -f 5)
sixth=$(echo $original | cut -d" " -f 6)
counter=1
echo "######################" > optimized.txt
while [ $counter -le $n_steps ]
do
	mpprun pw.x -in "$input_file" > "$output_file"
	energy=$(grep -i "total energy" "$output_file" | grep -Eo '[-+][0-9]+[.]+[0-9]'+ | tail -1)
	echo "$original $energy" >> optimized.txt
	new_first=$(python -c "print $first + 1")
	new_second=$(python -c "print $second + 1")
	new="   $new_first $new_second 1 0 0 0"
	sed -i "s/$original/$new/" "$input_file"
	original=$new
	first=$(echo $original | cut -d" " -f 1)
	second=$(echo $original | cut -d" " -f 2)
	third=$(echo $original | cut -d" " -f 3)
	fourth=$(echo $original | cut -d" " -f 4)
	fifth=$(echo $original | cut -d" " -f 5)
	sixth=$(echo $original | cut -d" " -f 6)

	echo "Iteration ---->> $counter"
	((counter++))
done

./plotting.sh

echo "Finished"

