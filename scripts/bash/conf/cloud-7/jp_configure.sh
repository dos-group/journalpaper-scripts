#!/bin/bash

# Configures all variables of all experiments.
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

################ GENERAL EXPERIMENT

# path to the various Myriad data generators (wordcount-gen, tera-gen)
DGEN_HOME=${JP_SCRIPTS_HOME}/datagen
# path to experiments log file folder
EXP_LOG_BASE_DIR=${JP_SCRIPTS_HOME}/log
# path to the experiment jobs
JOBS_HOME=${JP_SCRIPTS_HOME}/jobs
# list of all available slaves, top N slaves will be used for dop N
ALL_SLAVES=${JP_SCRIPTS_HOME}/scripts/bash/conf/cloud-7/all_slaves
# list of all current slaves
CUR_SLAVES=${JP_SCRIPTS_HOME}/scripts/bash/conf/cloud-7/cur_slaves
# number of repetition runs
NUM_REPETITION_RUNS=3
# user that runs the experiments
EXP_USER=aalexandrov
# user group for the experiments
EXP_GROUP=users

################ HADOOP

# path to Hadoop MR deployment archive
HADOOPMR_TAR=/share/journalpaper/systems/hadoop-1.0.4.tar.gz
# path to Hadoop MR root folder
HADOOPMR_HOME=/share/journalpaper/systems/hadoop-1.0.4
# host name of the Hadoop MR jobtracker
HADOOPMR_JOBTRACKER_HOST=cloud-7
# timeout in seconds to bring up Hadoop MR (let all tasktrackers connect)
HADOOPMR_STARTUP_CHECK_TIMEOUT=180
# interval in seconds to check whether Hadoop MR is ready
HADOOPMR_STARTUP_CHECK_INTERVAL=5
# number of map slots per tasktracker
HADOOPMR_MAP_SLOTS_PER_SLAVE=8

################ STRATOSPHERE

# path to Stratosphere deployment archive
STRATOSPHERE_TAR=/share/journalpaper/systems/stratosphere-0.2.tar.gz
# path to Stratosphere root folder
STRATOSPHERE_HOME=/share/journalpaper/systems/stratosphere-0.2
# host name of the Hadoop MR jobtracker
STRATOSPHERE_JOBMANAGER_HOST=cloud-7
# timeout in seconds to bring up Stratosphere (let all taskmanagers connect)
STRATOSPHERE_STARTUP_CHECK_TIMEOUT=180
# interval in seconds to check whether Stratosphere is ready
STRATOSPHERE_STARTUP_CHECK_INTERVAL=5
# time in seconds to wait for Stratosphere to shutdown
STRATOSPHERE_SHUTDOWN_WAITTIME=10

################ HDFS

# path to HDFS root folder
HDFS_HOME=${HADOOPMR_HOME}
# host name of the HDFS namenode
HDFS_NAMENODE_HOST=cloud-7
# timeout in second to bring HDFS up (leave safe-mode and let all datanodes connect)
HDFS_STARTUP_CHECK_TIMEOUT=180
# interval in seconds to check whether HDFS is ready
HDFS_STARTUP_CHECK_INTERVAL=5
# directory where all datanodes store their data
HDFS_DATA_DIR=/data/hdfs/data
# direactory where the namenode stores its data 
HDFS_NAME_DIR=/data/hdfs/name
# HDFS address
HDFS_ADDRESS=hdfs://cloud-7:45010

################ HDFS LOCATIONS

# path for input data in HDFS
HDFS_INPUT_PATH=/benchmarks/input
# HDFS directory where all job results are written to
HDFS_OUTPUT_PATH=/benchmarks/output

################ AUTOMATICALLY DERIVED

WC_GEN_HOME=${DGEN_HOME}/wordcount-gen
TS_GEN_HOME=${DGEN_HOME}/tera-gen
TPCH_GEN_HOME=${DGEN_HOME}/tpch-gen

HDFS_BIN=${HDFS_HOME}/bin
HDFS_LOG=${HDFS_HOME}/logs
HDFS_CONF=${HDFS_HOME}/conf

HADOOPMR_BIN=${HADOOPMR_HOME}/bin
HADOOPMR_LOG=${HADOOPMR_HOME}/logs
HADOOPMR_CONF=${HADOOPMR_HOME}/conf

STRATOSPHERE_BIN=${STRATOSPHERE_HOME}/bin
STRATOSPHERE_CONF=${STRATOSPHERE_HOME}/conf
STRATOSPHERE_LOG=${STRATOSPHERE_HOME}/log
