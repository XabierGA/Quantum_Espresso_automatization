#!/bin/bash

input_file=$1
output_file=$2
increments=$3
n_steps=$4
original=$(grep -i "ecutwfc" "$input_file" | grep -Eo '[0-9]+[.]+[0-9]'+ | tail -1)
counter=1
echo "######################" > optimized.txt
while [ $counter -le $n_steps ]
do
	mpprun pw.x -in "$input_file" > "$output_file"
	energy=$(grep -i "total energy" "$output_file" | grep -Eo '[-+][0-9]+[.]+[0-9]'+ | tail -1)
	echo "$original $energy" >> optimized.txt
	new=$(python -c "print $original + $increments")
	echo $new
	sed -i "s/ecutwfc=$original/ecutwfc=$new/" "$input_file"
	original=$new
	echo "Iteration ---->> $counter"
	((counter++))
done

./plotting.sh

echo "Finished"

