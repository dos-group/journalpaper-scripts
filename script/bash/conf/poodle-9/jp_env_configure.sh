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
# wordcount-gen data generator home
EXP_WC_DGEN_HOME=${EXP_DGEN_HOME}/wordcount-gen
# tera-gen data generator home
EXP_TS_DGEN_HOME=${EXP_DGEN_HOME}/tera-gen
# tpch-gen data generator home
EXP_TPCH_DGEN_HOME=${EXP_DGEN_HOME}/tpch-gen

################ HDFS

# path to HDFS root folder
HDFS_HOME=${HDP_MAPR_HOME}
# HDFS bin folder
HDFS_BIN=${HDFS_HOME}/bin
# HDFS log folder
HDFS_LOG=${HDFS_HOME}/logs
# HDFS con folder
HDFS_CONF=${HDFS_HOME}/conf
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
# host name of the Hadoop MapReduce jobtracker
HDP_MAPR_JOBTRACKER_HOST=poodle-9

################ STRATOSPHERE

# Stratosphere deployment archive
STR_PACT_TAR=/home/alexander/etc/stratosphere-0.2.tar.gz
# Stratosphere deployment archive used for Meteor
STR_PACT_TAR_METEOR=/home/alexander/etc/stratosphere-0.2-meteor.tar.gz
# Stratosphere root folder
STR_PACT_HOME=/home/alexander/etc/stratosphere-0.2
# Stratosphere bin folder
STR_PACT_BIN=${STR_PACT_HOME}/bin
# Stratosphere conf folder
STR_PACT_CONF=${STR_PACT_HOME}/conf
# Stratosphere log folder
STR_PACT_LOG=${STR_PACT_HOME}/log
# Stratosphere Job Manager host name
STR_PACT_JOBMANAGER_HOST=poodle-9
