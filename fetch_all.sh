#!/bin/bash

# synced directories
source_dir=`pwd`
dest_dir=/share/journalpaper/experiments/.

#ssh options
ssh_host=cloud-7.dima.tu-berlin.de
ssh_user=aalexandrov

rsync -a -v -r -e "ssh -l ${ssh_user}" --exclude-from="${source_dir}/fetch_all.excludes" ${ssh_host}:${dest_dir} ${source_dir}
