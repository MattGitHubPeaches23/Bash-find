#!/bin/bash

a=[^\\t]+; f=$a; l=$a; e=$a; ((n=1<<31))
# echo START
# echo $f
# echo END

while getopts :f:l:e:n: o; do
    if [[ $o =~ f|l|e|n ]]; then
        eval $o=$OPTARG
		# echo '$o = ' $o
		# echo '$OPTARG = ' $OPTARG
		# echo '$f = ' $f 
		# echo '$l = ' $l
    fi
done

if ! [[ "$f$l$e" =~ ^("$a"){3}$ ]]; then
    grep -E "$(printf "$f\t$l\t$e")" data.txt | sort -k2,2 -k1,1 -k3,3 | head -n $n
fi