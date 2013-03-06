#!/bin/bash

# load config
. ./jp_configure.sh

  #################################
  # adapt configuration
  #################################

  # plugin config switch here

  #################################
  # repeat runs
  #################################

  # repeat Stratosphere Runs

BUFFER_SETTING_NAMES=("8192_64K")
BUFFER_CONFIG_SUFFIXES=("1")

RUN_NAMES=("PUSH" "PULL-W1" "PULL-W2" "PULL-W3")
WAVES=(1 1 2 3);
CONFS=("nephele-user.xml.push" "nephele-user.xml.pull" "nephele-user.xml.pull" "nephele-user.xml.pull")

for buffconf in ${!BUFFER_SETTING_NAMES[*]}
do
   buff_name=${BUFFER_SETTING_NAMES[$buffconf]};
   buff_suffix=${BUFFER_CONFIG_SUFFIXES[$buffconf]};

   for widx in ${!WAVES[*]}
   do
      num_waves=${WAVES[$widx]};
      conf=${CONFS[$widx]};
      run_name=${RUN_NAMES[$widx]};

      rm "/home/stratosphere/stratosphere-0.2/conf/nephele-user.xml"
      ln -s "${conf}.${buff_suffix}" "/home/stratosphere/stratosphere-0.2/conf/nephele-user.xml"

      ./jp_run_repeated.sh STR STR-1NSORTJOIN-${run_name}-${buff_name} "-v -j /home/stratosphere/push-pull/jobs/stratosphere-jobs/stratosphere-jobs-0.1-MT_Hash_Join.jar -a 6 hdfs://master:9000/1nJoin/PK hdfs://master:9000/1nJoin/FK hdfs://master:9000/result ${num_waves}"
   done
done
