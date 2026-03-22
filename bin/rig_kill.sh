#!/bin/zsh
# kill rigctrld

# Check if hamlib rigctld is running. If it is, kill it.
rigctld_pid=`pgrep -x rigctld`
if [[ "${rigctld_pid}" != "" ]] ; then
    echo "killing rigctld:"
    ps ax ${rigctld_pid}
    kill -9 ${rigctld_pid}
else
    echo "rigctrld is not running, not kilt"
fi
