#!/bin/bash

# Configures the environment for experiments.
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)
# Author: Alexander Alexandrov (alexander.alexandrov@tu-berlin.de)

################ GENERAL EXPERIMENT

# number of repetition runs
EXP_NUM_REPETITION_RUNS=3
# user that runs the experiments
EXP_USER=hadoop
# user group for the experiments
EXP_GROUP=hadoop
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

################ HDFS

# path to HDFS root folder
HDFS_HOME=/share/hadoop/journalpaper/systems/hadoop-1.0.4
# HDFS bin folder
HDFS_BIN=${HDFS_HOME}/bin
# HDFS log folder
HDFS_LOG=${HDFS_HOME}/logs
# HDFS con folder
HDFS_CONF=${HDFS_HOME}/conf
# HDFS address
HDFS_ADDRESS=hdfs://cloud-11:45010
# host name of the HDFS namenode
HDFS_NAMENODE_HOST=cloud-11
# directory where all datanodes store their data
HDFS_DATA_DIR=/data/1/journalpaper/hdfs-data,/data/2/journalpaper/hdfs-data,/data/3/journalpaper/hdfs-data,/data/4/journalpaper/hdfs-data
# direactory where the namenode stores its data
HDFS_NAME_DIR=/data/journalpaper/hdfs-name

################ HADOOP

# path to Hadoop MapReduce deployment archive
HDP_MAPR_TAR=/share/hadoop/journalpaper/systems/hadoop-1.0.4.tar.gz
# path to Hadoop MapReduce root folder
HDP_MAPR_HOME=/share/hadoop/journalpaper/systems/hadoop-1.0.4
# Hadoop bin dir
HDP_MAPR_BIN=${HDP_MAPR_HOME}/bin
# Hadoop log dir
HDP_MAPR_LOG=${HDP_MAPR_HOME}/logs
# Hadoop conf dir
HDP_MAPR_CONF=${HDP_MAPR_HOME}/conf
# Hadoop MapReduce Job Tracker host name
HDP_MAPR_JOBTRACKER_HOST=cloud-11
# number of map slots per tasktracker
HDP_MAPR_MAP_SLOTS_PER_SLAVE=8

################ STRATOSPHERE

# Stratosphere deployment archive
STR_PACT_TAR=/share/hadoop/journalpaper/systems/stratosphere-0.2.tar.gz
# Stratosphere deployment archive used for Meteor
STR_PACT_TAR_METEOR=/share/hadoop/journalpaper/systems/stratosphere-0.2-meteor.tar.gz
# Stratosphere root folder
STR_PACT_HOME=/share/hadoop/journalpaper/systems/stratosphere-0.2
# Stratosphere bin folder
STR_PACT_BIN=${STR_PACT_HOME}/bin
# Stratosphere conf folder
STR_PACT_CONF=${STR_PACT_HOME}/conf
# Stratosphere log folder
STR_PACT_LOG=${STR_PACT_HOME}/log
# Stratosphere Job Manager host name
STR_PACT_JOBMANAGER_HOST=cloud-11
