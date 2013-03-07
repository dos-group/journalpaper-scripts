#!/bin/bash

# Deploys a hadoop distribution from an archive.
#
# Author: Alexander Alexandrov (alexander.alexandrov@tu-berlin.de)

# load configuration
. ./jp_env_configure.sh

echo "Removing Hadoop install folder '${HDP_MAPR_HOME}'."
rm -Rf ${HDP_MAPR_HOME}

echo "Deploying Hadoop version from '${HDP_MAPR_TAR}' to '${HDP_MAPR_HOME}'."
tar -xzvf ${HDP_MAPR_TAR} -C `dirname ${HDP_MAPR_HOME}` > /dev/null
chown -R ${EXP_USER}:${EXP_GROUP} ${HDP_MAPR_HOME}
