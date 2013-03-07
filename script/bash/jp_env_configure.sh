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
# path to experiments log file folder
EXP_LOG_DIR=${EXP_SCRIPT_DIR}/log
# path to the experiment jobs
EXP_JOBS_HOME=${EXP_SCRIPT_DIR}/jobs
# list of all available slaves, top N slaves will be used for dop N
EXP_ALL_SLAVES=${EXP_SCRIPT_DIR}/script/bash/conf/alexander-sl510/all_slaves
# list of all current slaves
EXP_CUR_SLAVES=${EXP_SCRIPT_DIR}/script/bash/conf/alexander-sl510/cur_slaves

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
# number of map slots per tasktracker
HDP_MAPR_MAP_SLOTS_PER_SLAVE=2

################ STRATOSPHERE

# timeout in seconds to bring up Stratosphere (let all taskmanagers connect)
STR_PACT_STARTUP_CHECK_TIMEOUT=180
# interval in seconds to check whether Stratosphere is ready
STR_PACT_STARTUP_CHECK_INTERVAL=5
# time in seconds to wait for Stratosphere to shutdown
STR_PACT_SHUTDOWN_WAITTIME=10

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
