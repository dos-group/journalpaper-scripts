#!/bin/bash

# Formats the HDFS, starts it and waits until it became
# operational (all data nodes connected, safe mode disabled)
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

USER=`whoami`

# load configuration
. ./jp_env_configure.sh

# paranoid check for suspicious 'HDFS_DATA_DIR' values
if [[ "$HDFS_DATA_DIR" =~ /data/[0-9]+/hadoop ]]; then
   echo "Paranoid interrupt of HDFS format: we really think it is a a bad idea to use the given 'HDFS_DATA_DIR'."
   exit 1
fi

# check that HDFS is not running!
pid=${HDFS_PID}/hadoop-${USER}-namenode.pid
if [ -f $pid ]; then
   if kill -0 `cat $pid` > /dev/null 2>&1; then
      echo "HDFS is already running. Skipping startAndWait() procedure."
      exit
   fi
fi

# remove log files
rm -Rf ${HDFS_LOG}/hadoop-${USER}-*node-*.log* > /dev/null
echo "Removed HDFS log files."

if [ ! -f ${EXP_CUR_SLAVES} ]; then
   echo "Current slaves file ${EXP_CUR_SLAVES} does not exist. Canceling..."
   exit 1
fi

# adapt number of datanodes
cp ${EXP_CUR_SLAVES} ${HDFS_CONF}/slaves > /dev/null
echo "Number of datanodes adapted."
SLAVECNT=`cat ${EXP_CUR_SLAVES} | wc -l`

# format namenode
echo "Formatting HDFS..."
echo "Y" | ${HDFS_BIN}/hadoop namenode -format > /dev/null 2> /dev/null
echo "Formatting HDFS ready."

for datanode in $(cat ${HDFS_CONF}/slaves); do
   for dataDir in $(echo $HDFS_DATA_DIR | sed 's/,/ /g'); do
      echo "Initializing data dir ${dataDir} at datanode ${datanode}."
      ssh ${USER}@${datanode} "rm -Rf ${dataDir}/current" > /dev/null
      ssh ${USER}@${datanode} "mkdir -p ${dataDir}/current" > /dev/null
      echo "Copying namenode VERSION file to datanode ${datanode}."
      scp ${HDFS_NAME_DIR}/current/VERSION ${USER}@${datanode}:${dataDir}/current/VERSION.backup > /dev/null
      echo "Adapt VERSION file on ${datanode}."
      ssh ${USER}@${datanode} "cat ${dataDir}/current/VERSION.backup | sed '3 i storageID=' | sed 's/storageType=NAME_NODE/storageType=DATA_NODE/g' > ${dataDir}/current/VERSION" > /dev/null
      ssh ${USER}@${datanode} "rm -Rf ${dataDir}/current/VERSION.backup" > /dev/null
   done
done

# start hdfs
echo "Starting HDFS..."
${HDFS_BIN}/start-dfs.sh > /dev/null

# wait until hdfs is started
echo "Waiting for all datanodes to connect and HDFS to turn safe mode off..."
safeModeOff=0
nodeCnt=0
timeoutCnt=0
while [[ ( $safeModeOff -eq 0 ) && ( $nodeCnt -lt $SLAVECNT ) && ( $timeoutCnt -lt $HDFS_STARTUP_CHECK_TIMEOUT ) ]]; do
   sleep $HDFS_STARTUP_CHECK_INTERVAL
   safeModeOff=`cat ${HDFS_LOG}/hadoop-${USER}-namenode-${HDFS_NAMENODE_HOST}.log | grep "leaving safe mode" | wc -l`
   nodeCnt=`cat ${HDFS_LOG}/hadoop-${USER}-namenode-${HDFS_NAMENODE_HOST}.log | grep "NameSystem.registerDatanode:" | wc -l`
   (( timeoutCnt+=$HDFS_STARTUP_CHECK_INTERVAL ))
done

if [[ $timeoutCnt == $HDFS_STARTUP_CHECK_TIMEOUT ]]; then
   echo "HDFS did not start within timeout. Shutting it down..."
   ${HDFS_BIN}/stop-dfs.sh > /dev/null
   echo "HDFS is now shut down."
   exit 1
fi

# make sure that the Hive tmp dir exists
${HDFS_BIN}/hadoop dfs -test -e /tmp
if ! [[ $? -eq 0 ]]; then
   ${HDFS_BIN}/hadoop fs -mkdir /tmp
   ${HDFS_BIN}/hadoop fs -chmod g+w /tmp
fi

# make sure that the Hive home dir exists
${HDFS_BIN}/hadoop dfs -test -e /user/hive/warehouse
if ! [[ $? -eq 0 ]]; then
   ${HDFS_BIN}/hadoop fs -mkdir /user/hive/warehouse
   ${HDFS_BIN}/hadoop fs -chmod g+w /user/hive/warehouse
fi

echo "HDFS is now ready for use (all datanodes are connected, safe mode turned off) "
