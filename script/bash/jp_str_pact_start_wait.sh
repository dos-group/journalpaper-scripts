#!/bin/bash

# Starts Hadoop's MapReduce framework and waits until
# all TaskTrackers have been connected to the JobTracker.
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load configuration
. ./jp_env_configure.sh

USER=`whoami`

# check that Nephele is not running!
if [[ `jps | grep JobManager | wc -l` > 0 ]]
then
   echo "Stratosphere is already running. Skipping startAndWait() procedure."
   exit
fi

# check that file with current slaves exists
if [ ! -f ${EXP_CUR_SLAVES} ]
then
   echo "Current slaves file ${EXP_CUR_SLAVES} does not exist."
   exit 1
fi

# remove log files
rm -Rf ${STR_PACT_LOG}/nephele-${USER}-*.log*
rm -Rf ${STR_PACT_LOG}/nephele-${USER}-*.out*
echo "Stratosphere log files removed"

# adapt number of tasktrackers
cp ${EXP_CUR_SLAVES} ${STR_PACT_CONF}/slaves
echo "Number of tasktrackers adapted"
SLAVECNT=`cat ${EXP_CUR_SLAVES} | wc -l`

# start Nephele cluster
echo "starting Nephele"
${STR_PACT_BIN}/start-cluster.sh > /dev/null
echo "Nephele started"

# wait until all task managers connected
echo "waiting for $SLAVECNT TaskManagers to connect..."
nodeCnt=0
timeoutCnt=0
while [[ ( $nodeCnt -lt $SLAVECNT ) && ( $timeoutCnt -lt $STR_PACT_STARTUP_CHECK_TIMEOUT ) ]]
do
   sleep $STR_PACT_STARTUP_CHECK_INTERVAL
   nodeCnt=`cat ${STR_PACT_LOG}/nephele-${USER}-jobmanager-*.log | grep "Creating instance" | wc -l`
   (( timeoutCnt+=$STR_PACT_STARTUP_CHECK_INTERVAL ))
done

if [[ $timeoutCnt == $STR_PACT_STARTUP_CHECK_TIMEOUT ]]
then
   echo "Nephele did not start within timeout. Shutting it down"
   ${STR_PACT_BIN}/stop-cluster.sh > /dev/null
   echo "Nephele shut down"
   exit 1
fi

echo "All TaskManagers connected. Nephele ready for use."
