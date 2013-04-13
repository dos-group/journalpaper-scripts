#!/bin/bash

. ./utils.sh

DIR_RESULTS=../../result/final
SCALE_FACTOR="0010 0020 0030 0040 0050"
DOP="0040 0080 0120 0160 0200"
EXPERIMENT="wc-str_pact wc_jst-str_pact wc-hdp_mapr ts-hdp_mapr ts-str_pact"

for exp in $EXPERIMENT; do
	OUTPUT_FILE="csv/$exp.csv"

	##
	# Main loop
	##

	> $OUTPUT_FILE
	for sf in $SCALE_FACTOR; do 
		for dop in $DOP; do
			dir="$exp-sf$sf-dop$dop";
			runtime=`getRuntime $dir`
			if [ $runtime ]; then # check that we have a result
				echo "$dop,$runtime" >> $OUTPUT_FILE
			fi
		done # dop
	done # scale factor
done # experiment




