#!/bin/bash

host=$1
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo $host
if ! [[ "$host" =~ cloud-(7|11) ]]; then
   echo "You need to specify a valid host name as first argument (one of cloud-7 or cloud-11). Canceling..."
   exit 1
fi

if ! [[ -f "$dir/$host.config" ]]; then
   echo "Could not find configuration file './cloud-7.config'. Canceling..."
   exit 1
fi

# include config
. $dir/$host.config

# execute rsync
echo ""
echo "Fetching files from remote host."
rsync -a -v -r -e "ssh -l ${host_user}" --exclude-from="${dir}/rsync.excludes" $dir/../. ${host_name}:${host_dest}

# make sure that all files have the given group
echo ""
echo "Adapting group of remote files."
ssh -l ${host_user} ${host_name} "find ${host_dest} -type d | xargs -I{} chown ${host_user}:${host_group} {}" > /dev/null 2> /dev/null
ssh -l ${host_user} ${host_name} "find ${host_dest} -type f | xargs -I{} chown ${host_user}:${host_group} {}" > /dev/null 2> /dev/null
# make sure that the files are accessible by other members of the group
echo ""
echo "Adapting group rights of remote files."
ssh -l ${host_user} ${host_name} "find ${host_dest} -type d | xargs -I{} chmod g+w {}" > /dev/null 2> /dev/null
ssh -l ${host_user} ${host_name} "find ${host_dest} -type f | xargs -I{} chmod g+w {}" > /dev/null 2> /dev/null
