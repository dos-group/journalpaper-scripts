#!/bin/bash

# load config
. ./jp_env_configure.sh

# deploy systems under test (SUTs)
./jp_sut_deploy.sh ${HDP_MAPR_TAR} ${HDP_MAPR_HOME}
./jp_sut_deploy.sh ${STR_PACT_TAR} ${STR_PACT_HOME}

# start: March 6th, 14:15 AM;
# end:   ???
./jp_run_wordcount.sh 4
./jp_run_terasort.sh 4
