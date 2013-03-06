#!/bin/bash

# Deploys a hadoop distribution from an archive.
#
# Author: Alexander Alexandrov (alexander.alexandrov@tu-berlin.de)

# load configuration
. ./jp_configure.sh

echo "Removing Stratosphere install folder '${STRATOSPHERE_HOME}'." 
rm -Rf ${STRATOSPHERE_HOME}

echo "Deploying Stratosphere version from '${STRATOSPHERE_TAR}' to '${STRATOSPHERE_HOME}'."
tar -xzvf ${STRATOSPHERE_TAR} -C `dirname ${STRATOSPHERE_HOME}` > /dev/null
chown -R ${EXP_USER}:${EXP_GROUP} ${STRATOSPHERE_HOME}