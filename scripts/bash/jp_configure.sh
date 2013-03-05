#!/bin/bash

# common environment variables
PWD=`pwd`
JP_SCRIPTS_HOME=`dirname $PWD`
JP_SCRIPTS_HOME=`dirname $JP_SCRIPTS_HOME`

# load currently active configuration
configFile=${JP_SCRIPTS_HOME}/scripts/bash/conf/${HOSTNAME}/jp_configure.sh
if [ ! -f $configFile ]; then
  echo "Missing config file '${configFile}'. Canceling..."
  exit 1
else
  . ${configFile}
fi