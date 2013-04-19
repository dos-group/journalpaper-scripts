#!/bin/bash

# load config
. ./jp_env_configure.sh

# deploy systems under test (SUTs)
./jp_sut_deploy.sh ${HDP_MAPR_TAR} ${HDP_MAPR_HOME}
./jp_sut_deploy.sh ${STR_PACT_TAR} ${STR_PACT_HOME}

# set initial dop
dopOld=2
# adapt number of slaves
./jp_env_adapt_slave_cnt.sh $dopOld
# format and start HDFS
./jp_hdfs_format_start_wait.sh
if [[ $? != 0 ]]; then
   exit $?
fi

# read log directory, and for each job
for jobPath in $( find "$EXP_SCRIPT_DIR/log" -mindepth 1 -maxdepth 1 -type d | sort ); do
   
   jobExecutionID=$(basename $jobPath )
   jobLogPath="$jobPath/run.log"
   jobErrPath="$jobPath/run.err"
   jobOutPath="$jobPath/run.out"
   
   # identify failed jobs
   if [[ -f $jobLogPath && "$( cat $jobLogPath | cut -c50-52 )" -ne "-1" ]]; then
       continue
   fi
   
   # reconstruct job execution input variables
   jobID=$( echo "$jobExecutionID" | cut -d- -f1) 
   systemID=$( echo "$jobExecutionID" | cut -d- -f2) 
   sf=$( echo "$jobExecutionID" | cut -d- -f3) 
   dop=$( echo "$jobExecutionID" | cut -d- -f4) 
   run=$( echo "$jobExecutionID" | cut -d- -f5) 
   suffix=$( echo "$jobExecutionID" | cut -d- -f6)
   
   # skip old job runs
   if [[ "$suffix" =~ ^old[0-9]+$ ]] ; then
      continue
   fi

   echo ""
   echo "Examining failed job ${jobExecutionID}."

   # verify the input parameters, continue on error
   # jobID
   if ! [[ "$jobID" =~ ^wc_jst|wc|ts|q3|cc$ ]] ; then
	  echo "Bad job ID '${jobID}'. Skipping ${jobExecutionID}..."
	  continue
   fi
   # systemID
   if ! [[ "$systemID" =~ ^str_(pact|metr|iter)|hdp_(mapr|hive|grph)$ ]] ; then
      echo "Bad job ID '${systemID}'. Skipping ${jobExecutionID}..."
      continue
   fi
   # scaling factor
   if ! [[ "$sf" =~ ^sf[0-9]+$ ]] ; then
      echo "Bad SF '${sf}'. Skipping ${jobExecutionID}..."
      continue
   else
      sf=$( echo "$sf" | cut -c3- | sed 's/^0*//g' )
   fi
   # dop
   if ! [[ "$dop" =~ ^dop[0-9]+$ ]] ; then
      echo "Bad DOP '${dop}'. Skipping ${jobExecutionID}..."
      continue
   else
      dop=$( echo "$dop" | cut -c4- | sed 's/^0*//g' )
   fi
   # run
   if ! [[ "$run" =~ ^run[0-9]+$ ]] ; then
      echo "Bad run '${run}'. Skipping ${jobExecutionID}..."
      continue
   else
      run=$( echo "$run" | cut -c4- | sed 's/^0*//g' )
   fi

   # if everything is OK, re-execute the job
   # re-execution step (0): reconstruct input parameters for the run job script
   execSystem=$( echo $systemID | tr '[:lower:]' '[:upper:]' )
   execIDPref=$( echo "$jobExecutionID" | sed 's/-run[0-9]*$//g' )
   jobString=$( cat "$jobLogPath" | cut -c60- | tr -d '"' )

   # re-execution step (1): re-start the hdfs on DOP change
   if [[ $dopOld -ne $dop ]]; then
      # adapt number of slaves
      newNumSlaves=$(( $dop / $HDP_MAPR_MAP_SLOTS_PER_SLAVE ))
      ./jp_env_adapt_slave_cnt.sh $newNumSlaves
      # clean & stop HDFS
	  ./jp_hdfs_clean_stop.sh
      # format and start HDFS
      ./jp_hdfs_format_start_wait.sh
      if [[ $? != 0 ]]; then
         exit $?
      fi
   fi

   # re-execution step (2): lazy-load the dataset required for the job
   # terasort
   if [[ "$jobID" =~ ^ts$ ]] ; then 
      datasetID=`printf "terasort-sf%04d" ${sf}`
      # lazy-load dataset
      if ${HDFS_BIN}/hadoop fs -test -e ${HDFS_INPUT_PATH}/${datasetID}; then
         echo "Dataset '${datasetID}' already exists. Skipping data generation phase..."
      else
         echo "Lazy-loading dataset '${datasetID}'."
         ./jp_load_data_terasort.sh ${sf} ${dop} ${datasetID}
         if [[ $? != 0 ]]; then
            exit $?
         fi
      fi
   # wordcount
   elif [[ "$jobID" =~ ^wc_jst|wc$ ]] ; then 
      datasetID=`printf "wordcount-sf%04d" ${sf}`
      # lazy-load dataset
      if ${HDFS_BIN}/hadoop fs -test -e ${HDFS_INPUT_PATH}/${datasetID}; then
         echo "Dataset '${datasetID}' already exists. Skipping data generation phase..."
      else
         echo "Lazy-loading dataset '${datasetID}'."
         ./jp_load_data_wordcount.sh ${sf} ${dop} ${datasetID}
         if [[ $? != 0 ]]; then
            exit $?
         fi
      fi
   # tpch Q3
   elif [[ "$jobID" =~ ^q3$ ]] ; then 
      datasetID=`printf "tpch-sf%04d" ${sf}`
      # lazy-load dataset
      if ${HDFS_BIN}/hadoop fs -test -e ${HDFS_INPUT_PATH}/${datasetID}; then
         echo "Dataset '${datasetID}' already exists. Skipping data generation phase..."
      else
         echo "Lazy-loading dataset '${datasetID}'."
         ./jp_load_data_tpch.sh ${sf} ${dop} ${datasetID}
         if [[ $? != 0 ]]; then
            exit $?
         fi
      fi
   # twitter
   elif [[ "$jobID" =~ ^cc$ ]] ; then 
      datasetID=`printf "tpch-sf%04d" ${sf}`
      # lazy-load dataset
      if ${HDFS_BIN}/hadoop fs -test -e ${HDFS_INPUT_PATH}/${datasetID}; then
         echo "Dataset '${datasetID}' already exists. Skipping data generation phase..."
      else
         echo "Lazy-loading dataset '${datasetID}'."
         ./jp_load_data_tpch.sh ${sf} ${dop} ${datasetID}
         if [[ $? != 0 ]]; then
            exit $?
         fi
      fi
   fi
   
   # re-execution step (3): move old execution
   mv $jobPath $jobPath-old01

   # re-execution step (4): rerun the job execution
   ./jp_run_repeated.sh $execSystem $execIDPref "$jobString" $run
   
   # update the dop for the next iteration
   dopOld=$dop
done

# stop HDFS
./jp_hdfs_clean_stop.sh
