#!/bin/bash

# Executes a Stratosphere job and measures the execution time.
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
outFile=${EXP_LOG_DIR}/${EXP_ID}/run.out
logFile=${EXP_LOG_DIR}/${EXP_ID}/run.log

# make sure that the output folder is empty
if ${HDFS_BIN}/hadoop fs -test -e ${HDFS_OUTPUT_PATH}; then
   echo "Removing old job output path ${HDFS_OUTPUT_PATH}"
   ${HDFS_BIN}/hadoop fs -rmr ${HDFS_OUTPUT_PATH}
fi
# re-create the job output folder
echo "Creating fresh job output path ${HDFS_OUTPUT_PATH}"
${HDFS_BIN}/hadoop fs -mkdir ${HDFS_OUTPUT_PATH}

# make sure that the initial solution set exists
${HDFS_BIN}/hadoop fs -touchz ${HDFS_ADDRESS}${HDFS_INPUT_PATH}/twitter-icwsm2010/initialSolutionset
${HDFS_BIN}/hadoop fs -touchz ${HDFS_ADDRESS}${HDFS_INPUT_PATH}/twitter-icwsm2010/graph

# start job
echo "Starting job execution for experiment ${EXP_ID}."
startTS=`date +%s`
pact_libs=$(find ${STR_PACT_HOME}/lib -name '*.jar' | xargs echo | tr ' ' ':')
java -cp $pact_libs $JOB_STRING > $outFile 2> $errFile

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

# copy Stratosphere log files
mkdir -p ${EXP_LOG_DIR}/${EXP_ID}/stratosphere-logs
cp ${STR_PACT_LOG}/* ${EXP_LOG_DIR}/${EXP_ID}/stratosphere-logs

# clean result dir
echo "Removing job output path ${HDFS_OUTPUT_PATH}"
${HDFS_BIN}/hadoop fs -rmr ${HDFS_OUTPUT_PATH}