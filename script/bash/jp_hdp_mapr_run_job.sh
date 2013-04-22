#!/bin/bash

# Executes a Hadoop job and measures the execution time.
# The default result path is removed.
# Parameters:
# 1) EXP_ID the key for this experiment
# 2) JOB_STRING that gives the job jar and all job arguments
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load configuration
. ./jp_env_configure.sh

USER=`whoami`
EXP_ID=$1
JOB_STRING=$2

# check that experiment ID is set
if [[ $EXP_ID == '' ]]; then
   echo "You need to specify an experiment ID. Canceling..."
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
errFile=${EXP_LOG_DIR}/${EXP_ID}/run.err
logFile=${EXP_LOG_DIR}/${EXP_ID}/run.log
outFile=${EXP_LOG_DIR}/${EXP_ID}/run.out

# make sure that the output folder is empty
if ${HDFS_BIN}/hadoop fs -test -e ${HDFS_OUTPUT_PATH}; then
   echo "Removing old job output path ${HDFS_OUTPUT_PATH}"
   ${HDFS_BIN}/hadoop fs -rmr ${HDFS_OUTPUT_PATH}
fi
# re-create the job output folder
# echo "Creating fresh job output path ${HDFS_OUTPUT_PATH}"
# ${HDFS_BIN}/hadoop fs -mkdir ${HDFS_OUTPUT_PATH}

# start job
echo "Starting job execution for experiment ${EXP_ID}."
startTS=`date +%s`
${HDP_MAPR_BIN}/hadoop jar $JOB_STRING > $outFile 2> $errFile

if [[ $? == 0 ]]; then
   endTS=`date +%s`
   (( jobDuration=$endTS - $startTS ))
   line=`printf "%-50s%-30s\n" $EXP_ID $jobDuration`
   echo "$line" \"$JOB_STRING\" > $logFile
   echo "Job executed in $jobDuration seconds."
else
   line=`printf "%-50s%-30s\n" $EXP_ID -1`
   echo "$line" \"$JOB_STRING\" > $logFile
   echo "Job execution failed!"
fi

# copy Hadoop MapReduce job log file
mkdir -p ${EXP_LOG_DIR}/${EXP_ID}/hadoop-logs
${HDFS_BIN}/hadoop fs -copyToLocal ${HDFS_OUTPUT_PATH}/_logs/history ${EXP_LOG_DIR}/${EXP_ID}/hadoop-logs
