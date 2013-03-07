#!/bin/bash

# Executes a Hadoop job and measures the execution time.
# The default result path is removed.
# Parameters:
# 1) ExecutionId to identify the execution run
# 2) JOB_STRING that gives the job jar and all job arguments
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load configuration
. ./jp_env_configure.sh

EXP_ID=$1
JOB_STRING=$2

if [[ $EXP_ID == '' ]]; then
   echo "You need to specify an execution id. Canceling..."
   exit 1
fi

if [[ $JOB_STRING == '' ]]; then
   echo "You need to specify a job string for execution. Canceling..."
   exit 1
fi

# create run log folder
mkdir -p ${EXP_LOG_DIR}/${EXP_ID}
# derive name of log and output files
outFile=${EXP_LOG_DIR}/${EXP_ID}/run.out
logFile=${EXP_LOG_DIR}/${EXP_ID}/run.log

echo "Starting to execute job: $JOB_STRING"
startTS=`date +%s`
${HDP_MAPR_BIN}/hadoop jar $JOB_STRING > $outFile

if [[ $? == 0 ]]; then
   endTS=`date +%s`
   (( jobDuration=$endTS - $startTS ))
   line=`printf "%-50s%-30s\n" $EXP_ID $jobDuration`
   echo "$line" \"$JOB_STRING\" >> $logFile
   echo "Job executed in $jobDuration seconds."
else
   line=`printf "%-50s%-30s\n" $EXP_ID -1`
   echo "$line" \"$JOB_STRING\" >> $logFile
   echo "Job execution failed!"
fi

# copy Hadoop log file
mkdir -p ${EXP_LOG_DIR}/${EXP_ID}/hadoop-logs
${HDFS_BIN}/hadoop fs -copyToLocal ${HDFS_OUTPUT_PATH}/_logs/history ${EXP_LOG_DIR}/${EXP_ID}/hadoop-logs

# clean result dir
${HDFS_BIN}/hadoop fs -rmr ${HDFS_OUTPUT_PATH}
