#!/bin/bash

# repeats one experiment multiple times and collects all logs.
# the chosen execution system may not be running when the script is started!
# Parameters:
# 1) Execution System: System to run the job on (HDP, HON, STR)
# 2) ExecutionID-Prefix: Prefix for the execution id
# 3) Job String to execute

EXEC_SYSTEM=$1
EXEC_ID_PREF=$2
JOB_STRING=$3

if [[ $EXEC_SYSTEM != 'HDP'  && $EXEC_SYSTEM != 'STR' ]]
then
  echo "You need to specify an system to execute (HDP, STR). Canceling..."
  exit 1
fi

if [[ $EXEC_ID_PREF == '' ]]
then
  echo "You need to specify an experiment id prefix. Canceling..."
  exit 1
fi

if [[ $JOB_STRING == '' ]]
then
  echo "You need to specify an job string for execution. Canceling..."
  exit 1
fi

# load configuration
. ./jp_configure.sh

if [[ $EXEC_SYSTEM == 'HDP' ]]
then
  # start Hadoop
  ./jp_hadoop_mr_start_wait.sh
  if [[ $? != 0 ]]
  then  
    exit $?
  fi
fi

# Start run loop
for (( i=1; i<=${NUM_REPETITION_RUNS}; i++ ))
do
  EXP_ID=`printf "%s-run%02d" ${EXEC_ID_PREF} ${i}`

  # create log dirs
  mkdir -p ${EXP_LOG_BASE_DIR}/${EXP_ID}
  
  # run job
  if [[ $EXEC_SYSTEM == 'HDP' ]]
  then
    # run Hadoop MR job
    ./jp_hadoop_mr_run_job.sh $EXP_ID "${JOB_STRING}"
  elif [[ $EXEC_SYSTEM == 'STR' ]]
  then
    # start Stratosphere
    ./jp_stratosphere_start_wait.sh
    if [[ $? != 0 ]]
    then  
      exit $?
    fi
    # run Stratosphere job
    ./jp_stratosphere_run_job.sh $EXP_ID "${JOB_STRING}"
    # stop Stratosphere
    ./jp_stratosphere_stop.sh
  fi

  # delete the result files
  ${HDFS_BIN}/hadoop dfs -rmr ${HDFS_OUTPUT_PATH}
done

if [[ $EXEC_SYSTEM == 'HDP' ]]
then
  # stop Hadoop
  ./jp_hadoop_mr_stop.sh
  if [[ $? != 0 ]]
  then  
    exit $?
  fi
fi
