#!/bin/bash

image_list=image_list.txt
image_suffix='jpeg'
sizes_list=sizes_list.txt
mogrify_input_dir=mogrify_input
mogrify_output_dir=mogrify_output


while read sizes; do
	size=$sizes
	while read images; do
		image=$images.$image_suffix
		bash mogrify.sh $mogrify_input_dir/$image $size $mogrify_output_dir
	done < $image_list
done < $sizes_list
