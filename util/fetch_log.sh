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
rsync -a -v -r -e "ssh -l ${host_user}" --include="log-*" --include="log-*/**" --exclude="*" ${host_name}:${host_dest}/. $dir/../
