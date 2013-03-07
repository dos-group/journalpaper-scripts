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

echo $EXEC_SYSTEM
if [[ "HDP_MAPR|HDP_HIVE|STR_PACT|STR_MET" =~ $EXEC_SYSTEM ]]; then
   RUNTIME_SYSTEM=`echo $EXEC_SYSTEM | sed -E 's/(HDP|STR)_(MAPR|HIVE|PACT|METR)/\1/'`
   echo "Using ${RUNTIME_SYSTEM} runtime system" # concatenate strings
   if [[ $RUNTIME_SYSTEM =~ "HDP" ]]; then
      FRONTEND_SYSTEM=`echo $EXEC_SYSTEM | sed -E 's/HDP_(MAPR|HIVE)/\1/'`
   else # RUNTIME_SYSTEM == "STR"
      FRONTEND_SYSTEM=`echo $EXEC_SYSTEM | sed -E 's/STR_(PACT|METR)/\1/'`
   fi
   echo "Using ${FRONTEND_SYSTEM} programming API" # concatenate strings
else
   echo "You need to specify an system + API pair to execute (one of HDP_MAPR, HDP_HIVE, STR_PACT, STR_MTOR is expected)."
   echo "Canceling..."
   exit 1
fi

if [[ $EXEC_ID_PREF == '' ]]; then
   echo "You need to specify an experiment id prefix. Canceling..."
   exit 1
fi

if [[ $JOB_STRING == '' ]]; then
   echo "You need to specify an job string for execution. Canceling..."
   exit 1
fi

# load configuration
. ./jp_env_configure.sh

if [[ $RUNTIME_SYSTEM == 'HDP' ]]; then
   
   # start Hadoop MapReduce
   ./jp_hdp_mapr_start_wait.sh
   if [[ $? != 0 ]]; then
      exit $?
   fi
   
   # Start run loop
   for (( i=1; i<=${EXP_NUM_REPETITION_RUNS}; i++ )); do
      EXP_ID=`printf "%s-run%02d" ${EXEC_ID_PREF} ${i}`
      
      # create log dir for experiment
      mkdir -p ${EXP_LOG_DIR}/${EXP_ID}
      
      # run job
      if [[ $FRONTEND_SYSTEM == 'MAPR' ]]; then
         ./jp_hdp_mapr_run_job.sh $EXP_ID "${JOB_STRING}"
      elif [[ $FRONTEND_SYSTEM == 'HIVE' ]]
      
   fi
   
   # delete the result files
   ${HDFS_BIN}/hadoop dfs -rmr ${HDFS_OUTPUT_PATH}
   
done

# stop Hadoop MapReduce
./jp_hdp_mapr_stop.sh
if [[ $? != 0 ]]
then
   exit $?
fi

elif [[ $RUNTIME_SYSTEM == 'STR' ]]; then

# Start run loop
for (( i=1; i<=${EXP_NUM_REPETITION_RUNS}; i++ )); do
   # start Stratosphere
   ./jp_stratosphere_start_wait.sh
   if [[ $? != 0 ]]; then
      exit $?
   fi
   
   # run job
   if [[ $FRONTEND_SYSTEM == 'PACT' ]]; then
      # run Stratosphere PACT job
      ./jp_str_pact_run_job.sh $EXP_ID "${JOB_STRING}"
   fi
   
   # stop Stratosphere
   ./jp_str_stop.sh
done

fi # Hadoop

# Start run loop
for (( i=1; i<=${EXP_NUM_REPETITION_RUNS}; i++ )); do

EXP_ID=`printf "%s-run%02d" ${EXEC_ID_PREF} ${i}`

# create log dirs
mkdir -p ${EXP_LOG_DIR}/${EXP_ID}

# run job
if [[ $EXEC_SYSTEM == 'HDP' ]]
then
   # run Hadoop MR job
   ./jp_hdp_mapr_run_job.sh $EXP_ID "${JOB_STRING}"
elif [[ $EXEC_SYSTEM == 'STR' ]]
then
   # start Stratosphere
   ./jp_stratosphere_start_wait.sh
   if [[ $? != 0 ]]
   then
      exit $?
   fi
   # run Stratosphere job
   ./jp_str_pact_run_job.sh $EXP_ID "${JOB_STRING}"
   # stop Stratosphere
   ./jp_str_stop.sh
fi

# delete the result files
${HDFS_BIN}/hadoop dfs -rmr ${HDFS_OUTPUT_PATH}
done

if [[ $EXEC_SYSTEM == 'HDP' ]]
then
# stop Hadoop
./jp_hdp_mapr_stop.sh
if [[ $? != 0 ]]
then
   exit $?
fi
fi
