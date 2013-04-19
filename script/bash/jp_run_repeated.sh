#!/bin/bash

# repeats one experiment multiple times and collects all logs.
# the chosen execution system may not be running when the script is started!
# Parameters:
# 1) Execution System: System to run the job on (HDP, HON, STR)
# 2) ExecutionID-Prefix: Prefix for the execution id
# 3) Job String to execute

EXEC_SYSTEM=$1
EXEC_ID_PREF=$2
JOB_STRING=$3
RUN_ID=$4

if [[ "HDP_MAPR|HDP_HIVE|HDP_GRPH|STR_PACT|STR_ITER|STR_METR" =~ $EXEC_SYSTEM ]]; then
   RUNTIME_SYSTEM=`echo $EXEC_SYSTEM | sed -E 's/(HDP|STR)_(MAPR|HIVE|PACT|ITER|METR)/\1/'`
   echo "Using ${RUNTIME_SYSTEM} runtime system." # concatenate strings
   
   if [[ $RUNTIME_SYSTEM =~ "HDP" ]]; then
      FRONTEND_SYSTEM=`echo $EXEC_SYSTEM | sed -E 's/HDP_(MAPR|HIVE)/\1/'`
   else # RUNTIME_SYSTEM == "STR"
      FRONTEND_SYSTEM=`echo $EXEC_SYSTEM | sed -E 's/STR_(PACT|METR)/\1/'`
   fi
   echo "Using ${FRONTEND_SYSTEM} programming API." # concatenate strings
else
   echo "You need to specify an system + API pair to execute (one of HDP_MAPR, HDP_HIVE, STR_PACT, STR_MTOR is expected)."
   echo "Canceling..."
   exit 1
fi

if [[ $EXEC_ID_PREF == '' ]]; then
   echo "You need to specify an experiment id prefix. Canceling..."
   exit 1
fi

if [[ $JOB_STRING == '' ]]; then
   echo "You need to specify an job string for execution. Canceling..."
   exit 1
fi

# load configuration
. ./jp_env_configure.sh

if ! [[ $RUN_ID =~ ^[0-9]+$ ]] ; then
   RUN_FROM=1
   RUN_TO=${EXP_NUM_REPETITION_RUNS}
else
   RUN_FROM=$RUN_ID
   RUN_TO=$RUN_ID    
fi

if [[ $RUNTIME_SYSTEM == 'HDP' ]]; then
   
   # start Hadoop MapReduce
   ./jp_hdp_mapr_start_wait.sh
   if [[ $? != 0 ]]; then
      # start Hadoop MapReduce (2nd try)
      ./jp_hdp_mapr_stop.sh
      ./jp_hdp_mapr_start_wait.sh
      if [[ $? != 0 ]]; then
         # start Hadoop MapReduce (3rd try)
         ./jp_hdp_mapr_stop.sh
         ./jp_hdp_mapr_start_wait.sh
         if [[ $? != 0 ]]; then
            exit $?
         fi
      fi
   fi

   # Start run loop
   for (( i=${RUN_FROM}; i<=${RUN_TO}; i++ )); do
      # compute experiment ID for this job run
      EXP_ID=`printf "%s-run%02d" ${EXEC_ID_PREF} ${i}`
      # run job
      if [[ $FRONTEND_SYSTEM == 'MAPR' ]]; then
         ./jp_hdp_mapr_run_job.sh $EXP_ID "${JOB_STRING}"
      elif [[ $FRONTEND_SYSTEM == 'HIVE' ]]; then
         ./jp_hdp_hive_run_job.sh $EXP_ID "${JOB_STRING}"
      elif [[ $FRONTEND_SYSTEM == 'GRPH' ]]; then
         ./jp_hdp_grph_run_job.sh $EXP_ID "${JOB_STRING}"
      fi
   done

   # stop Hadoop MapReduce
   ./jp_hdp_mapr_stop.sh
   if [[ $? != 0 ]]; then
      exit $?
   fi

elif [[ $RUNTIME_SYSTEM == 'STR' ]]; then

    # Start run loop
    for (( i=${RUN_FROM}; i<=${RUN_TO}; i++ )); do
       # start Stratosphere
       ./jp_str_pact_start_wait.sh
       if [[ $? != 0 ]]; then
          # start Stratosphere (2nd try)
          ./jp_str_pact_stop.sh
          ./jp_str_pact_start_wait.sh
          if [[ $? != 0 ]]; then
              # start Stratosphere (3nd try)
              ./jp_str_pact_stop.sh
              ./jp_str_pact_start_wait.sh
              if [[ $? != 0 ]]; then
                  exit $?
              fi
          fi
       fi

       # compute experiment ID for this job run
       EXP_ID=`printf "%s-run%02d" ${EXEC_ID_PREF} ${i}`
       # run job
       if [[ $FRONTEND_SYSTEM == 'PACT' ]]; then
          # run Stratosphere PACT job
          ./jp_str_pact_run_job.sh $EXP_ID "${JOB_STRING}"
       elif [[ $FRONTEND_SYSTEM == 'ITER' ]]; then
          # run Stratosphere Iterations as plain Nephele job
          ./jp_str_iter_run_job.sh $EXP_ID "${JOB_STRING}"
       elif [[ $FRONTEND_SYSTEM == 'METR' ]]; then
          echo "Skipping unsupported frontend 'Meteor'"
          # ./jp_hdp_metr_run_job.sh $EXP_ID "${JOB_STRING}"
       fi
       
       # stop Stratosphere
       ./jp_str_pact_stop.sh
       if [[ $? != 0 ]]; then
          exit $?
       fi
    
    done

fi # Stratosphere
