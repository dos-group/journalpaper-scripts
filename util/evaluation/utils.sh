# $1 is filename
function getRuntime {
	ARR=()
	for run in 01 02 03; do
		FULL_PATH=$DIR_RESULTS/$1-run$run/run.log
		if ! [ -a $FULL_PATH ]; then # check if file exists
			exit
		fi
		ARR+=(`cat $FULL_PATH | tr -s [:space:] | cut --delimiter=' ' -f 2`)
	done
	#find maximum
	max=0
	for n in "${ARR[@]}" ; do
    	((n > max)) && max=$n
	done
	total=$((${ARR[0]}+${ARR[1]}+${ARR[2]}-$max)) 
	avg=$((total/2))
	echo $avg #return average
}