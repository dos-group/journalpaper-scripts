#!/bin/bash

# load config
. ./jp_env_configure.sh

# deploy systems under test (SUTs)
./jp_sut_deploy.sh ${HDP_MAPR_TAR} ${HDP_MAPR_HOME}
./jp_sut_deploy.sh ${STR_PACT_TAR_ITERATIONS} ${STR_PACT_HOME}

#  5 nodes
#./jp_run_concomp.sh 5
# 10 nodes
./jp_run_cc.sh 10
# 15 nodes
./jp_run_cc.sh 15
# 20 nodes
./jp_run_cc.sh 20
# 25 nodes
./jp_run_cc.sh 25
