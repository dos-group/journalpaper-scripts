#!/bin/bash

# Starts Hadoop's MapReduce framework and waits until
# all TaskTrackers have been connected to the JobTracker.
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load configuration
. ./jp_configure.sh

USER=`whoami`

# check that Nephele is not running!
if [[ `jps | grep JobManager | wc -l` > 0 ]]
then
  echo "Stratosphere is already running. Canceling..."
  exit 
fi

# check that file with current slaves exists
if [ ! -f ${CUR_SLAVES} ] 
then
  echo "Current slaves file ${CUR_SLAVES} does not exist. Canceling..."
  exit 1
fi

# remove log files
rm ${STRATOSPHERE_LOG}/nephele-${USER}-*.log*
echo "Stratosphere log files removed"

# adapt number of tasktrackers
cp ${CUR_SLAVES} ${STRATOSPHERE_CONF}/slaves
echo "Number of tasktrackers adapted"
SLAVECNT=`cat ${CUR_SLAVES} | wc -l`

# start Nephele cluster
echo "starting Nephele"
${STRATOSPHERE_BIN}/start-cluster.sh
echo "Nephele started"

# wait until all task managers connected
echo "waiting for $SLAVECNT TaskManagers to connect"
nodeCnt=0
timeoutCnt=0
while [[ ( $nodeCnt -lt $SLAVECNT ) && ( $timeoutCnt -lt $STRATOSPHERE_STARTUP_CHECK_TIMEOUT ) ]]
do
  sleep $STRATOSPHERE_STARTUP_CHECK_INTERVAL
  nodeCnt=`cat ${STRATOSPHERE_LOG}/nephele-${USER}-jobmanager-*.log | grep "Creating instance" | wc -l`
  (( timeoutCnt+=$STRATOSPHERE_STARTUP_CHECK_INTERVAL ))
done

if [[ $timeoutCnt == $STRATOSPHERE_STARTUP_CHECK_TIMEOUT ]]
then
  echo "Nephele did not start within timeout. Shutting it down"
  ${STRATOSPHERE_BIN}/stop-cluster.sh
  echo "Nephele shut down"
  exit 1
fi

echo "All TaskManagers connected. Nephele ready for use."

