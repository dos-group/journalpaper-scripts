#!/bin/bash

# Deploys a system distribution from an archive.
#
# Author: Alexander Alexandrov (alexander.alexandrov@tu-berlin.de)

SYSTEM_TAR=$1
SYSTEM_HOME=$2

if [[ $SYSTEM_TAR == '' ]]
then
   echo "You need to specify a system tar.tz archive path for deployment. Canceling..."
   exit 1
fi

if [[ $SYSTEM_HOME == '' ]]
then
   echo "You need a system home folder for deployment. Canceling..."
   exit 1
fi

# load config
. ./jp_env_configure.sh

echo "Removing SUT home folder '${SYSTEM_HOME}'."
rm -Rf ${SYSTEM_HOME}

echo "Deploying SUT from '${SYSTEM_TAR}' to '${SYSTEM_HOME}'."
tar -xzvf ${SYSTEM_TAR} -C `dirname ${SYSTEM_HOME}` > /dev/null
chown -R ${EXP_USER}:${EXP_GROUP} ${SYSTEM_HOME}
