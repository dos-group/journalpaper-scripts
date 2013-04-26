#!/bin/bash

# Configures the environment for experiments.
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)
# Author: Alexander Alexandrov (alexander.alexandrov@tu-berlin.de)

################ GENERAL EXPERIMENT

# number of repetition runs
EXP_NUM_REPETITION_RUNS=1
# user that runs the experiments
EXP_USER=alexander
# user group for the experiments
EXP_GROUP=alexander
# list of all available slaves, top N slaves will be used for dop N
EXP_ALL_SLAVES=$(dirname ${CONFIG_FILE})/all_slaves
# list of all current slaves
EXP_CUR_SLAVES=$(dirname ${CONFIG_FILE})/cur_slaves
# wordcount-gen data generator home
EXP_WC_DGEN_HOME=${EXP_DGEN_HOME}/wordcount-gen
# tera-gen data generator home
EXP_TS_DGEN_HOME=${EXP_DGEN_HOME}/tera-gen
# tpch-gen data generator home
EXP_TPCH_DGEN_HOME=${EXP_DGEN_HOME}/tpch-gen
# Twitter ICWSM'2010 dataset local path
EXP_TWITTER_DATA_LOCAL=/data/real/twitter-icwsm
# SNAP Orkut graph local path
EXP_ORKUT_DATA_LOCAL=/data/real/com-orkut.ungraph.txt
# SNAP Pokec graph local path (undirected version)
EXP_POKEC_DATA_LOCAL=/data/real/soc-pokec-relationships.ungraph.txt
# SNAP Youtube graph local path
EXP_YOUTUBE_DATA_LOCAL=/data/real/com-youtube.ungraph.txt

################ HDFS

# path to HDFS root folder
HDFS_HOME=/home/alexander/etc/hadoop-1.0.4
# HDFS bin folder
HDFS_BIN=${HDFS_HOME}/bin
# HDFS con folder
HDFS_CONF=${HDFS_HOME}/conf
# HDFS log folder
HDFS_LOG=${HDFS_HOME}/logs
# HDFS PIDs folder
HDFS_PID=/tmp
# HDFS address
HDFS_ADDRESS=hdfs://localhost:9000
# host name of the HDFS namenode
HDFS_NAMENODE_HOST=poodle-9
# directory where all datanodes store their data
HDFS_DATA_DIR=/data/hdfs/data
# direactory where the namenode stores its data
HDFS_NAME_DIR=/data/hdfs/name

################ HADOOP

# path to Hadoop MapReduce deployment archive
HDP_MAPR_TAR=/home/alexander/etc/hadoop-1.0.4.tar.gz
# path to Hadoop MapReduce root folder
HDP_MAPR_HOME=/home/alexander/etc/hadoop-1.0.4
# Hadoop bin folder
HDP_MAPR_BIN=${HDP_MAPR_HOME}/bin
# Hadoop conf folder
HDP_MAPR_CONF=${HDP_MAPR_HOME}/conf
# Hadoop log folder
HDP_MAPR_LOG=${HDP_MAPR_HOME}/logs
# Hadoop PIDs folder
HDP_MAPR_PID=/tmp
# host name of the Hadoop MapReduce jobtracker
HDP_MAPR_JOBTRACKER_HOST=poodle-9
# number of map slots per tasktracker
HDP_MAPR_MAP_SLOTS_PER_SLAVE=4

################ STRATOSPHERE

# Stratosphere deployment archive
STR_PACT_TAR=/home/alexander/etc/stratosphere-0.2.tar.gz
# Stratosphere deployment archive used for Meteor
STR_PACT_TAR_METEOR=/home/alexander/etc/stratosphere-0.2-meteor.tar.gz
# Stratosphere deployment archive for iterations
STR_PACT_TAR_ITERATIONS=/home/alexander/etc/stratosphere-0.2-iterations.tar.gz
# Stratosphere root folder
STR_PACT_HOME=/home/alexander/etc/stratosphere-0.2
# Stratosphere bin folder
STR_PACT_BIN=${STR_PACT_HOME}/bin
# Stratosphere conf folder
STR_PACT_CONF=${STR_PACT_HOME}/conf
# Stratosphere log folder
STR_PACT_LOG=${STR_PACT_HOME}/log
# Stratosphere PIDs folder
STR_PACT_PID=/tmp
# Stratosphere Job Manager host name
STR_PACT_JOBMANAGER_HOST=poodle-9

################ HIVE

# Hive deployment archive
HDP_HIVE_TAR=/home/alexander/etc/hive-0.10.0.tar.gz
# Hive root folder
HDP_HIVE_HOME=/home/alexander/etc/hive-0.10.0
# Hive bin folder
HDP_HIVE_BIN=${HDP_HIVE_HOME}/bin
# Hive conf folder
HDP_HIVE_CONF=${HDP_HIVE_HOME}/conf
# Stratosphere log folder
HDP_HIVE_LOG=${HDP_HIVE_HOME}/log

################ GIRAPH
GIRAPH_JAR=/home/alexander/etc/giraph-TODO.jar