#!/bin/bash

# Stops Nephele
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load config
. ./jp_env_configure.sh

# shut down Nephele
${STR_PACT_BIN}/stop-cluster.sh
