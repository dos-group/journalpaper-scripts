#!/bin/bash

# Stops Nephele
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load config
. ./jp_configure.sh

# shut down Nephele
${STRATOSPHERE_BIN}/stop-cluster.sh
