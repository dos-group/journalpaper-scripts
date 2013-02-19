#!/bin/bash

# Configures all variables of all experiments.
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

################ GENERAL EXPERIMENT

# path to experiments log file folder
EXP_LOG_BASE_DIR=/home/alexander/etc/journalpaper-scripts/log
# path to the various Myriad data generators (wordcount-gen, tera-gen)
DGEN_HOME=/home/alexander/etc/datagen
# path to the experiment jobs
JOBS_HOME=/home/alexander/etc/journalpaper-scripts/jobs
# list of all available slaves, top N slaves will be used for dop N
ALL_SLAVES=/home/alexander/etc/journalpaper-scripts/scripts/bash/conf/alexander-sl510/all_slaves
# list of all current slaves
CUR_SLAVES=/home/alexander/etc/journalpaper-scripts/scripts/bash/conf/alexander-sl510/cur_slaves
# number of repetition runs
NUM_REPETITION_RUNS=1

################ HDFS

# path to HDFS root folder
HDFS_HOME=/home/alexander/etc/hadoop-0.20.203.0
# host name of the HDFS namenode
HDFS_NAMENODE_HOST=alexander-sl510
# timeout in second to bring HDFS up (leave safe-mode and let all datanodes connect)
HDFS_STARTUP_CHECK_TIMEOUT=180
# interval in seconds to check whether HDFS is ready
HDFS_STARTUP_CHECK_INTERVAL=5
# directory where all datanodes store their data
HDFS_DATA_DIR=/data/hdfs/data
# direactory where the namenode stores its data 
HDFS_NAME_DIR=/data/hdfs/name
# HDFS address
HDFS_ADDRESS=hdfs://localhost:9000

################ HADOOP

# path to Hadoop MR root folder
HADOOPMR_HOME=/home/alexander/etc/hadoop-0.20.203.0
# host name of the Hadoop MR jobtracker
HADOOPMR_JOBTRACKER_HOST=alexander-sl510
# timeout in seconds to bring up Hadoop MR (let all tasktrackers connect)
HADOOPMR_STARTUP_CHECK_TIMEOUT=180
# interval in seconds to check whether Hadoop MR is ready
HADOOPMR_STARTUP_CHECK_INTERVAL=5
# number of map slots per tasktracker
HADOOPMR_MAP_SLOTS_PER_SLAVE=2

################ STRATOSPHERE

# path to Stratosphere root folder
STRATOSPHERE_HOME=/home/alexander/etc/stratosphere-0.2
# host name of the Hadoop MR jobtracker
STRATOSPHERE_JOBMANAGER_HOST=alexander-sl510
# timeout in seconds to bring up Stratosphere (let all taskmanagers connect)
STRATOSPHERE_STARTUP_CHECK_TIMEOUT=180
# interval in seconds to check whether Stratosphere is ready
STRATOSPHERE_STARTUP_CHECK_INTERVAL=5
# time in seconds to wait for Stratosphere to shutdown
STRATOSPHERE_SHUTDOWN_WAITTIME=10

################ HDFS LOCATIONS

# path for input data in HDFS
HDFS_INPUT_PATH=/benchmarks/input
# HDFS directory where all job results are written to
HDFS_OUTPUT_PATH=/benchmarks/output

################ AUTOMATICALLY DERIVED

WC_GEN_HOME=${DGEN_HOME}/wordcount-gen
TS_GEN_HOME=${DGEN_HOME}/tera-gen

HDFS_BIN=${HDFS_HOME}/bin
HDFS_LOG=${HDFS_HOME}/logs
HDFS_CONF=${HDFS_HOME}/conf

HADOOPMR_BIN=${HADOOPMR_HOME}/bin
HADOOPMR_LOG=${HADOOPMR_HOME}/logs
HADOOPMR_CONF=${HADOOPMR_HOME}/conf

STRATOSPHERE_BIN=${STRATOSPHERE_HOME}/bin
STRATOSPHERE_CONF=${STRATOSPHERE_HOME}/conf
STRATOSPHERE_LOG=${STRATOSPHERE_HOME}/log
