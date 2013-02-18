#!/bin/bash

# Starts a Hadoop MR job to generate the data for
# tera sort tasks.
# Parameters:
# 1) data size in MB per configured slave
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

mbPerSlave=$1

if [[ $mbPerSlave == '' ]]
then
  echo "You need to specify data volume (MB) per slave. Canceling..."
  exit 1
fi

# load configuration
. ./jp_configure.sh

if [ ! -f ${CUR_SLAVES} ] 
then
  echo "Current slaves file ${CUR_SLAVES} does not exist. Canceling..."
  exit 1
fi

# get number of tasktrackers
SLAVECNT=`cat ${CUR_SLAVES} | wc -l`

mapSlots=$((${HADOOPMR_MAP_SLOTS_PER_SLAVE} * ${SLAVECNT}))

mbPerCluster=$(( $mbPerSlave * $SLAVECNT ))
lineCnt=$(( ($mbPerCluster * 1024 * 1024) / 100 ))

# generate wc data
${HADOOPMR_BIN}/hadoop jar ${HADOOPMR_HOME}/hadoop-*examples*.jar teragen -Dmapred.map.tasks=${mapSlots} -Ddfs.block.size=268435456 ${lineCnt} $TS_HDFS_PATH
echo "TeraSort data generated"
