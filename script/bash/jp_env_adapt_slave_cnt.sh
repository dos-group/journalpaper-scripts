#!/bin/bash

# Adapts the number of slaves for all subsequent script calls.
# Parameters:
# 1: new number of slaves
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

SLAVECNT=$1
USER=`whoami`

# check that $SLAVECNT is set
if ! [[ "$SLAVECNT" =~ ^[0-9]+$ ]] ; then
   echo "You need to specify a slave count. Canceling..."
   exit 1
fi

# load configuration
. ./jp_env_configure.sh

# adapt number of slaves
head -n ${SLAVECNT} ${EXP_ALL_SLAVES} > ${EXP_CUR_SLAVES}
echo "Number of slaves set to $SLAVECNT"
