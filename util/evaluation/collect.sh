#!/bin/bash

. ./utils.sh

DIR_RESULTS=../../result/final
DOP="40 80 120 160 200"
#EXPERIMENT="wc-str_pact wc_jst-str_pact wc-hdp_mapr ts-hdp_mapr ts-str_pact q3-hdp_hive q3-str_pact cc-hdp_grph cc-str_iter"
EXPERIMENT="ts_otf-hdp_mapr ts_otf-str_pact"

for exp in $EXPERIMENT; do
	OUTPUT_FILE="csv/$exp.csv"

	##
	# Main loop
	##

	> $OUTPUT_FILE
	for dop in $DOP; do
		if [[ $exp =~ ^cc-hdp_grph|cc-str_iter$ ]] ; then
			sf=37
		else
			sf=$[dop/4]
		fi
		dir="$exp-sf$sf-dop$dop";
		dir=`printf "%s-sf%04d-dop%04d" ${exp} ${sf} ${dop}`
		runtime=`getRuntime $dir`
		if [ $runtime ]; then # check that we have a result
			echo "$dop,$runtime" >> $OUTPUT_FILE
		fi
	done # dop
done # experiment




