#!/bin/bash

# Starts Hadoop's MapReduce framework and waits until
# all TaskTrackers have been connected to the JobTracker.
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load configuration
. ./jp_env_configure.sh

USER=`whoami`

# check that HadoopMR is not running!
if [[ `jps | grep JobTracker | wc -l` > 0 ]]; then
   echo "Hadoop MapReduce is already running. Skipping startAndWait() procedure."
   exit
fi

# check that file with current slaves exists
if [ ! -f ${EXP_CUR_SLAVES} ]; then
   echo "Current slaves file ${EXP_CUR_SLAVES} does not exist. Canceling..."
   exit 1
fi

# remove log files
rm -Rf ${HDP_MAPR_LOG}/hadoop-${USER}-*tracker-*.log* > /dev/null
echo "Hadoop MapReduce log files removed."

# adapt number of tasktrackers
cp ${EXP_CUR_SLAVES} ${HDP_MAPR_CONF}/slaves > /dev/null
echo "Number of task trackers adapted."
SLAVECNT=`cat ${EXP_CUR_SLAVES} | wc -l`

# start  HadoopMR
echo "Starting Hadoop MapReduce..."
${HDP_MAPR_BIN}/start-mapred.sh > /dev/null
echo "Hadoop MapReduce is now running."

# wait until HadoopMR is started
echo "Waiting for $SLAVECNT tasktrackers to connect..."
nodeCnt=0
timeoutCnt=0
while [[ ( $nodeCnt -lt $SLAVECNT ) && ( $timeoutCnt -lt $HDP_MAPR_STARTUP_CHECK_TIMEOUT ) ]]; do
   sleep $HDP_MAPR_STARTUP_CHECK_INTERVAL
   nodeCnt=`cat ${HDP_MAPR_LOG}/hadoop-${USER}-jobtracker-*.log | grep "Adding a new node:" | wc -l`
   (( timeoutCnt+=$HDP_MAPR_STARTUP_CHECK_INTERVAL ))
done

if [[ $timeoutCnt == $HDP_MAPR_STARTUP_CHECK_TIMEOUT ]]; then
   echo "Hadoop MapReduce did not start within timeout. Shutting it down..."
   ${HDP_MAPR_BIN}/stop-mapred.sh > /dev/null
   echo "Hadoop MapReduce is shut down."
   exit 1
fi

echo "Hadoop MapReduce is now ready for use (all tasktrackers connected)."
