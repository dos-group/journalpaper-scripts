#!/bin/bash

# common environment variables
PWD=`pwd`
JP_SCRIPT_DIR=`dirname $PWD`
JP_SCRIPT_DIR=`dirname $JP_SCRIPT_DIR`

# load currently active configuration
configFile=${JP_SCRIPT_DIR}/script/bash/conf/${HOSTNAME}/jp_configure.sh
if [ ! -f $configFile ]; then
  echo "Missing config file '${configFile}'. Canceling..."
  exit 1
else
  . ${configFile}
fi
