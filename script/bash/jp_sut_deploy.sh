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

systemConf=${EXP_SCRIPT_DIR}/script/bash/conf/${HOSTNAME}/$( basename $SYSTEM_HOME )
if [[ -d "$systemConf" ]]; then
   echo "Using SUT config from '${systemConf}' at '${SYSTEM_HOME}/conf'."
   rm -Rf ${SYSTEM_HOME}/conf > /dev/null
   mkdir ${SYSTEM_HOME}/conf > /dev/null
   cp -R ${systemConf}/* ${SYSTEM_HOME}/conf/. > /dev/null
else
   echo "Using bundled SUT config at '${SYSTEM_HOME}/conf'."
fi

echo "Setting proper rights in SUT home."
chown -R ${EXP_USER}:${EXP_GROUP} ${SYSTEM_HOME}
find ${SYSTEM_HOME} -type f | xargs -I{} chmod g+w {}
find ${SYSTEM_HOME} -type d | xargs -I{} chmod g+w {}
