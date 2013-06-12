#!/bin/bash

# load config
. ./jp_env_configure.sh

# deploy systems under test (SUTs)
./jp_sut_deploy.sh ${HDP_MAPR_TAR} ${HDP_MAPR_HOME}
#./jp_sut_deploy.sh ${STR_PACT_TAR} ${STR_PACT_HOME}
./jp_sut_deploy.sh ${OZN_PACT_TAR} ${OZN_PACT_HOME}

#  5 nodes
./jp_run_te.sh  25
# 10 nodes
./jp_run_te.sh  20
# 15 nodes
./jp_run_te.sh  15
# 20 nodes
./jp_run_te.sh  10
# 25 nodes
./jp_run_te.sh  5
