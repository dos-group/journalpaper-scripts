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
# Twitter ICWSM'2010 dataset local path
EXP_TWITTER_DATA_LOCAL=/data/users/aalexandrov/twitter-icwsm
# SNAP Orkut graph local path
EXP_ORKUT_DATA_LOCAL=/data/users/aalexandrov/com-orkut.ungraph.txt
# SNAP Pokec graph local path
EXP_POKEC_DATA_LOCAL=/data/users/aalexandrov/soc-pokec-relationships.ungraph.txt
# SNAP Youtube graph local path
EXP_YOUTUBE_DATA_LOCAL=/data/users/aalexandrov/com-youtube.ungraph.txt

################ HDFS

# path to HDFS root folder
HDFS_HOME=/share/hadoop/journalpaper/systems/hadoop-1.0.4
# HDFS bin folder
HDFS_BIN=${HDFS_HOME}/bin
# HDFS con folder
HDFS_CONF=${HDFS_HOME}/conf
# HDFS log folder
HDFS_LOG=${HDFS_HOME}/logs
# HDFS PIDs folder
HDFS_PID=/data/journalpaper/pid
# HDFS address
HDFS_ADDRESS=hdfs://cloud-11.dima.tu-berlin.de:45010
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
# Hadoop bin folder
HDP_MAPR_BIN=${HDP_MAPR_HOME}/bin
# Hadoop conf folder
HDP_MAPR_CONF=${HDP_MAPR_HOME}/conf
# Hadoop log folder
HDP_MAPR_LOG=${HDP_MAPR_HOME}/logs
# Hadoop PIDs folder
HDP_MAPR_PID=/data/journalpaper/pid
# host name of the Hadoop MapReduce jobtracker
HDP_MAPR_JOBTRACKER_HOST=cloud-11
# number of map slots per tasktracker
HDP_MAPR_MAP_SLOTS_PER_SLAVE=8

################ STRATOSPHERE

# Stratosphere deployment archive
STR_PACT_TAR=/share/hadoop/journalpaper/systems/stratosphere-0.2.tar.gz
# Stratosphere deployment archive used for Meteor
STR_PACT_TAR_METEOR=/share/hadoop/journalpaper/systems/stratosphere-0.2-meteor.tar.gz
# Stratosphere deployment archive for iterations
STR_PACT_TAR_ITERATIONS=/share/hadoop/journalpaper/systems/stratosphere-0.2-iterations.tar.gz
# Stratosphere root folder
STR_PACT_HOME=/share/hadoop/journalpaper/systems/stratosphere-0.2
# Stratosphere bin folder
STR_PACT_BIN=${STR_PACT_HOME}/bin
# Stratosphere conf folder
STR_PACT_CONF=${STR_PACT_HOME}/conf
# Stratosphere log folder
STR_PACT_LOG=${STR_PACT_HOME}/log
# Stratosphere PIDs folder
STR_PACT_PID=/data/journalpaper/pid
# Stratosphere Job Manager host name
STR_PACT_JOBMANAGER_HOST=cloud-11

################ OZONE

# Stratosphere deployment archive
OZN_PACT_TAR=/share/hadoop/journalpaper/systems/stratosphere-0.2-ozone.tar.gz
# Stratosphere root folder
OZN_PACT_HOME=/share/hadoop/journalpaper/systems/stratosphere-0.2-ozone
# Stratosphere bin folder
OZN_PACT_BIN=${OZN_PACT_HOME}/bin
# Stratosphere conf folder
OZN_PACT_CONF=${OZN_PACT_HOME}/conf
# Stratosphere log folder
OZN_PACT_LOG=${OZN_PACT_HOME}/log
# Stratosphere PIDs folder
OZN_PACT_PID=/data/journalpaper/pid
# Stratosphere Job Manager host name
OZN_PACT_JOBMANAGER_HOST=cloud-11

################ HIVE

# Hive deployment archive
HDP_HIVE_TAR=/share/hadoop/journalpaper/systems/hive-0.10.0.tar.gz
# Hive root folder
HDP_HIVE_HOME=/share/hadoop/journalpaper/systems/hive-0.10.0
# Hive bin folder
HDP_HIVE_BIN=${HDP_HIVE_HOME}/bin
# Hive conf folder
HDP_HIVE_CONF=${HDP_HIVE_HOME}/conf
# Stratosphere log folder
HDP_HIVE_LOG=${HDP_HIVE_HOME}/log

################ GIRAPH
GIRAPH_JAR=/share/hadoop/journalpaper/experiments/job/giraph-examples-0.2-SNAPSHOT-for-hadoop-1.0.2-jar-with-dependencies.jar
