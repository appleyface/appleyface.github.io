#!/bin/bash

image_list=knitting_image_list
image_suffix='jpeg'
sizes_list=sizes_list.txt
mogrify_input_dir=knitting_input
mogrify_output_dir=knitting_output


while read sizes; do
	size=$sizes
	while read images; do
		image=$images.$image_suffix
		bash mogrify.sh $mogrify_input_dir/$image $size $mogrify_output_dir
	done < $image_list
done < $sizes_list
