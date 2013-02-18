#!/bin/bash

# Stops Hadoop's MapReduce framework
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load config
. ./jp_configure.sh

# shut down HadoopMR
${HADOOPMR_BIN}/stop-mapred.sh
