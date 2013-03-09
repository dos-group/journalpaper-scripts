#!/bin/bash

# load config
. ./jp_env_configure.sh

# deploy systems under test (SUTs)
#./jp_sut_deploy.sh ${HDP_MAPR_TAR} ${HDP_MAPR_HOME}
#./jp_sut_deploy.sh ${STR_PACT_TAR} ${STR_PACT_HOME}

# read log directory, and for each job
for jobPath in $( find "$EXP_SCRIPT_DIR/log" -mindepth 1 -maxdepth 1 -type d | sort ); do
   
   jobExecutionID=$(basename $jobPath )
   jobLogPath="$jobPath/run.log"
   jobErrPath="$jobPath/run.err"
   jobOutPath="$jobPath/run.out"
   
   # identify failed jobs
   if [[ -f $jobLogPath && "$( cat $jobLogPath | cut -c50-52 )" -ne "-1" ]]; then
       continue
   fi

   echo "Examining job ${jobExecutionID} is -1"
   
   # reconstruct job execution input variables
   jobID=$( echo "$jobExecutionID" | cut -d- -f1) 
   systemID=$( echo "$jobExecutionID" | cut -d- -f2) 
   sf=$( echo "$jobExecutionID" | cut -d- -f3) 
   dop=$( echo "$jobExecutionID" | cut -d- -f4) 
   run=$( echo "$jobExecutionID" | cut -d- -f5) 

   # verify the input parameters, filtering on error
   echo $jobID $systemID $sf $dop $run

   # if everything is OK, re-execute the job
    
   # re-execution step (1): reconstruct input parameters for the run job script
   execSystem=$1
   execIDPref=$2
   jobString=$3
    
   # re-execution step (1): lazy-load the dataset required for the job
    
   # re-execution step (2): rerun the 
done