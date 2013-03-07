#!/bin/bash

# Starts Hadoop's MapReduce framework and waits until
# all TaskTrackers have been connected to the JobTracker.
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load configuration
. ./jp_env_configure.sh

USER=`whoami`

# check that HadoopMR is not running!
if [[ `jps | grep JobTracker | wc -l` > 0 ]]
then
   echo "Hadoop MR is already running. Canceling..."
   exit
fi

# check that file with current slaves exists
if [ ! -f ${EXP_CUR_SLAVES} ]
then
   echo "Current slaves file ${EXP_CUR_SLAVES} does not exist. Canceling..."
   exit 1
fi

# remove log files
rm ${HDP_MAPR_LOG}/hadoop-${USER}-*tracker-*.log*
echo "Hadoop MR log files removed"

# adapt number of tasktrackers
cp ${EXP_CUR_SLAVES} ${HDP_MAPR_CONF}/slaves
echo "Number of tasktrackers adapted"
SLAVECNT=`cat ${EXP_CUR_SLAVES} | wc -l`

# start  HadoopMR
echo "Starting Hadoop MR"
${HDP_MAPR_BIN}/start-mapred.sh
echo "Hadoop MR started"

# wait until HadoopMR is started
echo "Waiting for $SLAVECNT tasktrackers to connect"
nodeCnt=0
timeoutCnt=0
while [[ ( $nodeCnt -lt $SLAVECNT ) && ( $timeoutCnt -lt $HDP_MAPR_STARTUP_CHECK_TIMEOUT ) ]]
do
   sleep $HDP_MAPR_STARTUP_CHECK_INTERVAL
   nodeCnt=`cat ${HDP_MAPR_LOG}/hadoop-${USER}-jobtracker-*.log | grep "Adding a new node:" | wc -l`
   (( timeoutCnt+=$HDP_MAPR_STARTUP_CHECK_INTERVAL ))
done

if [[ $timeoutCnt == $HDP_MAPR_STARTUP_CHECK_TIMEOUT ]]
then
   echo "Hadoop MR did not start within timeout. Shutting it down"
   ${HDP_MAPR_BIN}/stop-mapred.sh
   echo "Hadoop MR shut down"
   exit 1
fi

echo "All tasktrackers connected. Hadoop MR ready for use."

