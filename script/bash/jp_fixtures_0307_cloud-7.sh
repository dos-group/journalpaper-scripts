#!/bin/bash

# load config
. ./jp_env_configure.sh

# deploy systems under test (SUTs)
./jp_sut_deploy.sh ${HDP_MAPR_TAR} ${HDP_MAPR_HOME}
./jp_sut_deploy.sh ${STR_PACT_TAR} ${STR_PACT_HOME}

./jp_run_wc.sh 4
./jp_run_ts.sh 4
