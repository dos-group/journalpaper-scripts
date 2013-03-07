#!/bin/bash

# Executes a Stratosphere job and measures the execution time.
# The default result path is removed.
# Parameters:
# 1) ExecutionId to identify the execution run
# 2) JOB_STRING that gives the job jar and all job arguments
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load configuration
. ./jp_env_configure.sh

USER=`whoami`

EXP_ID=$1
JOB_STRING=$2

# check that execution id is set
if [[ $EXP_ID == '' ]]; then
   echo "You need to specify an execution id. Canceling..."
   exit 1
fi

# check that job string is set
if [[ $JOB_STRING == '' ]]; then
   echo "You need to specify a job string for execution. Canceling..."
   exit 1
fi

# create run log folder
mkdir -p ${EXP_LOG_DIR}/${EXP_ID}
# derive name of log and output files
outFile=${EXP_LOG_DIR}/${EXP_ID}/run.out
logFile=${EXP_LOG_DIR}/${EXP_ID}/run.log

# start job
echo "Starting job execution for experiment ${EXP_ID}."
startTS=`date +%s`
${STR_PACT_BIN}/pact-client.sh run -w -j $JOB_STRING > $outFoutFile

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

# copy jobmanager log file
#logEnd=`cat ${STR_PACT_LOG}/nephele-${USER}-jobmanager-${STR_PACT_JOBMANAGER_HOST}.log | wc -l`
#logLength=$(( $logEnd - $logStart ))
#cat ${STR_PACT_LOG}/nephele-${USER}-jobmanager-${STR_PACT_JOBMANAGER_HOST}.log | tail -n $logLength > ${EXP_LOG_DIR}/${EXP_ID}-jobmanager-log
mkdir -p ${EXP_LOG_DIR}/${EXP_ID}/stratosphere-logs
cp ${STR_PACT_LOG}/* ${EXP_LOG_DIR}/${EXP_ID}/stratosphere-logs

# clean result dir
${HDFS_BIN}/hadoop fs -rmr ${HDFS_OUTPUT_PATH}