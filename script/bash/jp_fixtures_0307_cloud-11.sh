#!/bin/bash

# load config
. ./jp_env_configure.sh

# deploy systems under test (SUTs)
./jp_sut_deploy.sh ${HDP_MAPR_TAR} ${HDP_MAPR_HOME}
./jp_sut_deploy.sh ${STR_PACT_TAR} ${STR_PACT_HOME}

#  5 nodes
./jp_run_wc.sh  5
#./jp_run_ts.sh  5
# 10 nodes
./jp_run_wc.sh 10
#./jp_run_ts.sh  10
# 15 nodes
./jp_run_wc.sh 15
#./jp_run_ts.sh  15
# 20 nodes
./jp_run_wc.sh 20
#./jp_run_ts.sh  20
# 25 nodes
./jp_run_wc.sh 25
#./jp_run_ts.sh  25
