#!/bin/bash

# Formats the HDFS, starts it and waits until it became
# operational (all data nodes connected, safe mode disabled)
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

USER=`whoami`

# load configuration
. ./jp_configure.sh

# check that HDFS is not running!
if [[ `jps | grep NameNode | wc -l` > 0 ]]
then
  echo "HDFS is running. Canceling..."
  exit 
fi

# remove log files
rm ${HDFS_LOG}/hadoop-${USER}-*node-*.log*
echo "HDFS log files removed"

if [ ! -f ${CUR_SLAVES} ] 
then
  echo "Current slaves file ${CUR_SLAVES} does not exist. Canceling..."
  exit 1
fi

# adapt number of datanodes
cp ${CUR_SLAVES} ${HDFS_CONF}/slaves
echo "Number of datanodes adapted"
SLAVECNT=`cat ${CUR_SLAVES} | wc -l`

# format namenode
echo "Formatting HDFS"
echo "Y" | ${HDFS_BIN}/hadoop namenode -format
echo "HDFS is formated"


for datanode in $(cat ${HDFS_CONF}/slaves); do
  echo "Copying namenode VERSION file to datanode ${datanode}"
  scp ${HDFS_NAME_DIR}/current/VERSION ${USER}@${datanode}:${HDFS_DATA_DIR}/current/VERSION.backup > /dev/null
  echo "Adapt VERSION file on ${datanode}"
  ssh ${USER}@${datanode} "cat ${HDFS_DATA_DIR}/current/VERSION.backup | sed '3 i storageID=' | sed 's/storageType=NAME_NODE/storageType=DATA_NODE/g' > ${HDFS_DATA_DIR}/current/VERSION"
  ssh ${USER}@${datanode} "rm ${HDFS_DATA_DIR}/current/VERSION.backup"
done

# start hdfs
echo "Starting HDFS"
${HDFS_BIN}/start-dfs.sh
echo "HDFS started"

# wait until hdfs is started
echo "Waiting for all datanodes to connect and HDFS to turn safe mode off"
safeModeOff=0
nodeCnt=0
timeoutCnt=0
while [[ ( $safeModeOff -eq 0 ) && ( $nodeCnt -lt $SLAVECNT ) && ( $timeoutCnt -lt $HDFS_STARTUP_CHECK_TIMEOUT ) ]]
do
  sleep $HDFS_STARTUP_CHECK_INTERVAL
  safeModeOff=`cat ${HDFS_LOG}/hadoop-${USER}-namenode-${HDFS_NAMENODE_HOST}.log | grep "leaving safe mode" | wc -l`
  nodeCnt=`cat ${HDFS_LOG}/hadoop-${USER}-namenode-${HDFS_NAMENODE_HOST}.log | grep "NameSystem.registerDatanode:" | wc -l`
  (( timeoutCnt+=$HDFS_STARTUP_CHECK_INTERVAL ))
done

if [[ $timeoutCnt == $HDFS_STARTUP_CHECK_TIMEOUT ]]
then
  echo "HDFS did not start within timeout. Shutting it down"
  ${HDFS_BIN}/stop-dfs.sh
  echo "HDFS shut down"
  exit 1
fi

echo "All datanodes connected. Safe mode turned off. HDFS ready for use."

