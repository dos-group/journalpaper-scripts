#!/bin/bash

# Starts Hadoop's MapReduce framework and waits until
# all TaskTrackers have been connected to the JobTracker.
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load configuration
. ./jp_env_configure.sh

USER=`whoami`

# check that Nephele is not running!
pid=${OZN_PACT_PID}/nephele-${USER}-jobmanager.pid
if [ -f $pid ]; then
   if kill -0 `cat $pid` > /dev/null 2>&1; then
      echo "Stratosphere is already running. Skipping startAndWait() procedure."
      exit
   fi
fi

# check that file with current slaves exists
if [ ! -f ${EXP_CUR_SLAVES} ]
then
   echo "Current slaves file ${EXP_CUR_SLAVES} does not exist."
   exit 1
fi

# remove log files
rm -Rf ${OZN_PACT_LOG}/nephele-${USER}-*.log*
rm -Rf ${OZN_PACT_LOG}/nephele-${USER}-*.out*
echo "Stratosphere log files removed"

# adapt number of tasktrackers
cp ${EXP_CUR_SLAVES} ${OZN_PACT_CONF}/slaves
echo "Number of tasktrackers adapted"
SLAVECNT=`cat ${EXP_CUR_SLAVES} | wc -l`

# start Nephele cluster
echo "Starting Nephele"
${OZN_PACT_BIN}/start-cluster.sh > /dev/null

# wait until all task managers connected
echo "Waiting for $SLAVECNT TaskManagers to connect..."
nodeCnt=0
timeoutCnt=0
while [[ ( $nodeCnt -lt $SLAVECNT ) && ( $timeoutCnt -lt $OZN_PACT_STARTUP_CHECK_TIMEOUT ) ]]
do
   sleep $OZN_PACT_STARTUP_CHECK_INTERVAL
   nodeCnt=`cat ${OZN_PACT_LOG}/nephele-${USER}-jobmanager-*.log | grep "Creating instance" | wc -l`
   (( timeoutCnt+=$OZN_PACT_STARTUP_CHECK_INTERVAL ))
done

if [[ $timeoutCnt == $OZN_PACT_STARTUP_CHECK_TIMEOUT ]]
then
   echo "Nephele did not start within timeout. Shutting it down"
   ${OZN_PACT_BIN}/stop-cluster.sh > /dev/null
   echo "Nephele shut down"
   exit 1
fi

echo "All TaskManagers connected. Nephele ready for use."
