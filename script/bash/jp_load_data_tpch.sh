#!/bin/bash

# Starts a Hadoop MapReduce job to generate the data for word count tasks.
# Parameters:
# 1) scaling factor (sf = 1 ~ 1GB data)
# 2) node count
# 3) dataset ID
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)
# Author: Alexander Alexandrov (alexander.alexandrov@tu-berlin.de)

SCALING_FACTOR=$1
NODE_COUNT=$2
DATASET_ID=$3

if [[ $SCALING_FACTOR == '' ]]; then
   echo "You need to specify scaling factor per slave. Canceling..."
   exit 1
fi

if ! [[ "$NODE_COUNT" =~ ^[0-9]+$ ]]; then
   echo "You need to specify DOP. Canceling..."
   exit 1
fi

if [[ $DATASET_ID == '' ]]; then
   echo "You need to specify dataset ID. Canceling..."
   exit 1
fi

# load configuration
. ./jp_env_configure.sh

# start hadoop_mr
./jp_hdp_mapr_start_wait.sh
if [[ $? != 0 ]]; then
   # start hadoop_mr (second try)
   ./jp_hdp_mapr_stop.sh
   ./jp_hdp_mapr_start_wait.sh
   if [[ $? != 0 ]]; then
      exit $?
   fi
fi

# generate tpch data
${HDP_MAPR_BIN}/hadoop jar ${EXP_TPCH_DGEN_HOME}/bin/tpch-gen-driver-jobs.jar ${EXP_TPCH_DGEN_HOME} -s${SCALING_FACTOR} -N${NODE_COUNT} -m${DATASET_ID} -o${HDFS_INPUT_PATH} -xlineitem -xcustomer -xnation -xorder -xpart -xsupplier -xpart_supp -xregion
echo "TPCH data generated."

# generate tpch schema for hive
HIVE_SCHEMA_TMP=$EXP_SCRIPT_DIR/script/hive/tpch_schema.tpl
HIVE_SCHEMA_HQL=$EXP_SCRIPT_DIR/script/hive/tpch_schema.${DATASET_ID}.hql
HIVE_SCHEMA_SED_PATTERN='s/${IN}/'$(echo "${HDFS_INPUT_PATH}/${DATASET_ID}" | sed 's!\([]\*\$\/&[]\)!\\\1!g')'/g'
sed ${HIVE_SCHEMA_SED_PATTERN} ${HIVE_SCHEMA_TMP} > ${HIVE_SCHEMA_HQL}
${HDP_HIVE_BIN}/hive  --service cli -f ${HIVE_SCHEMA_HQL}
echo "TPCH Hive schema created."

# stop hadoop_mr
./jp_hdp_mapr_stop.sh
