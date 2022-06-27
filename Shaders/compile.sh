#!/bin/bash

#set your VULKAN_SDK location  before running
if [[ ! -x "./bintoc" ]]
then
	gcc bintoc.c -o bintoc
fi

find . -type f -name "*.vert" | \
	while read f; do glslangValidator -V ${f} --target-env vulkan1.1 -o "Compiled/Release/${f%.*}.vspv"; done

find . -type f -name "*.frag" | \
	while read f; do glslangValidator -V ${f} --target-env vulkan1.1 -o "Compiled/Release/${f%.*}.fspv"; done

find . -type f -name "*.comp" | \
	while read f; do
		filename=${f}
		substring="sops"
		if test "${filename#*$substring}" != "$filename"; then
			glslangValidator -V ${f} --target-env vulkan1.1 -o "Compiled/Release/${f%.*}.cspv";
		else
			glslangValidator -V ${f} --target-env vulkan1.1 -o "Compiled/Release/${f%.*}.cspv";
		fi
	done

find . -type f -name "*.vspv" | \
	while read f; do ./bintoc ${f} `basename ${f%.*}`_vert_spv ${f%.*}.vert.c; done

find . -type f -name "*.fspv" | \
	while read f; do ./bintoc ${f} `basename ${f%.*}`_frag_spv ${f%.*}.frag.c; done

find . -type f -name "*.cspv" | \
	while read f; do ./bintoc ${f} `basename ${f%.*}`_comp_spv ${f%.*}.comp.c; done