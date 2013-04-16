#!/bin/bash

NUM_SLAVES=$1

# check that $NUM_SLAVES is set
if ! [[ "$NUM_SLAVES" =~ ^[0-9]+$ ]] ; then
   echo "You need to specify DOP. Canceling..."
   exit 1
fi

# load config
. ./jp_env_configure.sh

TPCH_NODE_COUNT=$((${HDP_MAPR_MAP_SLOTS_PER_SLAVE} * ${NUM_SLAVES}))
TPCH_SCALING_FACTOR=$(( ${TPCH_NODE_COUNT} / 4 ))
TPCH_DGEN_ID=`printf "tpch-sf%04d" ${TPCH_SCALING_FACTOR}`
TPCH_IN=${HDFS_ADDRESS}${HDFS_INPUT_PATH}/${TPCH_DGEN_ID}
TPCH_OUT=${HDFS_ADDRESS}${HDFS_OUTPUT_PATH}

# adapt number of slaves
./jp_env_adapt_slave_cnt.sh $NUM_SLAVES

# format and start HDFS
./jp_hdfs_format_start_wait.sh
if [[ $? != 0 ]]; then
   exit $?
fi

# generate wordcount input data
./jp_load_data_tpch.sh ${TPCH_SCALING_FACTOR} ${TPCH_NODE_COUNT} ${TPCH_DGEN_ID}
if [[ $? != 0 ]]; then
   exit $?
fi

# prepare Hive script
TPCH_Q3_TMP=$EXP_SCRIPT_DIR/script/hive/tpch_Q3.tpl
TPCH_Q3_HQL=$EXP_SCRIPT_DIR/script/hive/tpch_Q3.${TPCH_DGEN_ID}.hql
cp ${TPCH_Q3_TMP} ${TPCH_Q3_HQL}
sed -i 's/${OUT}/'$(echo "${HDFS_OUTPUT_PATH}" | sed 's!\([]\*\$\/&[]\)!\\\1!g')'/g' ${TPCH_Q3_HQL}
sed -i 's/${NODE_COUNT}/'$(echo "${TPCH_NODE_COUNT}" | sed 's!\([]\*\$\/&[]\)!\\\1!g')'/g' ${TPCH_Q3_HQL}

# repeat Hive runs
execIdPrefix=`printf "q3-hdp_hive-sf%04d-dop%04d" ${TPCH_SCALING_FACTOR} ${TPCH_NODE_COUNT}`
./jp_run_repeated.sh HDP_HIVE $execIdPrefix "$TPCH_Q3_HQL"

# repeat Meteor runs TODO
#execIdPrefix=`printf "q3-str_metr-sf%04d-dop%04d" ${TPCH_SCALING_FACTOR} ${TPCH_NODE_COUNT}`
#./jp_run_repeated.sh STR_METR $execIdPrefix "${EXP_JOBS_HOME}/journalpaper-jobs-1.0.0-wordcount-pact.jar -a ${TPCH_NODE_COUNT} ${TPCH_IN} ${TPCH_OUT}"

# repeat PACT runs
execIdPrefix=`printf "q3-str_pact-sf%04d-dop%04d" ${TPCH_SCALING_FACTOR} ${TPCH_NODE_COUNT}`
./jp_run_repeated.sh STR_PACT $execIdPrefix "${EXP_JOBS_HOME}/journalpaper-jobs-1.0.0-tpch_Q3-pact.jar -a ${TPCH_NODE_COUNT} ${TPCH_IN} ${TPCH_OUT}"

# stop HDFS
./jp_hdfs_clean_stop.sh
