#!/bin/bash

# Configures the environment for experiments.
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)
# Author: Alexander Alexandrov (alexander.alexandrov@tu-berlin.de)

################ GENERAL EXPERIMENT

# current directolry
PWD=`pwd`
# path to the scripts project
EXP_SCRIPT_DIR=$(dirname $(dirname $PWD))
# path to experiments data generators home
EXP_DGEN_HOME=${EXP_SCRIPT_DIR}/datagen
# path to the experiment jobs
EXP_JOBS_HOME=${EXP_SCRIPT_DIR}/job
# path to experiments log file folder
EXP_LOG_DIR=${EXP_SCRIPT_DIR}/log

################ HDFS

# timeout in second to bring HDFS up (leave safe-mode and let all datanodes connect)
HDFS_STARTUP_CHECK_TIMEOUT=180
# interval in seconds to check whether HDFS is ready
HDFS_STARTUP_CHECK_INTERVAL=5
# path for input data in HDFS
HDFS_INPUT_PATH=/benchmarks/input
# HDFS directory where all job results are written to
HDFS_OUTPUT_PATH=/benchmarks/output

################ HADOOP

# timeout in seconds to bring up Hadoop MapReduce (let all tasktrackers connect)
HDP_MAPR_STARTUP_CHECK_TIMEOUT=180
# interval in seconds to check whether Hadoop MapReduce is ready
HDP_MAPR_STARTUP_CHECK_INTERVAL=5

################ STRATOSPHERE

# timeout in seconds to bring up Stratosphere (let all taskmanagers connect)
STR_PACT_STARTUP_CHECK_TIMEOUT=180
# interval in seconds to check whether Stratosphere is ready
STR_PACT_STARTUP_CHECK_INTERVAL=5
# time in seconds to wait for Stratosphere to shutdown
STR_PACT_SHUTDOWN_WAITTIME=10

################ OZONE

# timeout in seconds to bring up Stratosphere (let all taskmanagers connect)
OZN_PACT_STARTUP_CHECK_TIMEOUT=180
# interval in seconds to check whether Stratosphere is ready
OZN_PACT_STARTUP_CHECK_INTERVAL=5
# time in seconds to wait for Stratosphere to shutdown
OZN_PACT_SHUTDOWN_WAITTIME=10

################ HIVE

# timeout in seconds to bring up Hadoop MapReduce (let all tasktrackers connect)
HDP_HIVE_FOO=bar

################ HOST SPECIFIC

# load host specific configuration environment
CONFIG_FILE=${EXP_SCRIPT_DIR}/script/bash/conf/${HOSTNAME}/jp_env_configure.sh
if [ ! -f $CONFIG_FILE ]; then
   echo "Missing config file '${CONFIG_FILE}'."
   echo "Canceling..."
   exit 1
else
   . ${CONFIG_FILE}
fi
