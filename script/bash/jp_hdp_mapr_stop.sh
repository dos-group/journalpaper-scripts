#!/bin/bash

# Stops Hadoop's MapReduce framework
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load config
. ./jp_env_configure.sh

# shut down HadoopMR
${HDP_MAPR_BIN}/stop-mapred.sh > /dev/null

# make sure that there are no ghost JVMs
for slave in $(cat ${HDFS_CONF}/slaves); do
   ssh ${slave} "jps | grep 'Child' | grep -v 'Jps' | tr -s ' ' | cut -d ' ' -f 1 | xargs -I{} kill {}"; > /dev/null
done
