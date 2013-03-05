#!/bin/bash

# Deploys a hadoop distribution from an archive.
#
# Author: Alexander Alexandrov (alexander.alexandrov@tu-berlin.de)

echo "Removing Hadoop install folder '${HADOOPMR_HOME}'." 
rm -Rf ${HADOOPMR_HOME}

echo "Deploying Hadoop version from '${HADOOPMR_TAR}' to '${HADOOPMR_HOME}'."
tar -xzvf ${HADOOPMR_TAR} -C `dirname ${HADOOPMR_HOME}`
chown -R ${EXP_USER}:${EXP_GROUP} ${STRATOSPHERE_HOME}