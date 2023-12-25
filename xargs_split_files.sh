#!/usr/bin/bash

# TODO: use stdin of this script as file
# TODO: dry run

USAGE="$(basename $0) [-sd] N_THREADS FILE_IN COMMAND_LEFT [COMMAND_RIGHT]
splits the content of FILE_IN (linewise) in N_THREADS sections and runs 'COMMAND_LEFT parital_FILE_IN COMMAND_RIGHT &' on each section
    -h: show this help
    -s: pass the file section as stdin to the command
    -d: dry run *NOT IMPLEMENTED*
    N_THREADS: max number of threads to use
    FILE_IN: file to split
    COMMAND: command to run on each file section"

_usage() {
    echo "$USAGE"
}

while getopts "sdh" o; do
    case "${o}" in
        s)
            use_stdin=1
            ;;
        d)
            dry_run=1
            echo "*NOT IMPLEMENTED*"
            exit 2
            ;;
        h)
            _usage
            exit 0
            ;;
        *)
            _usage
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))


max=$1
file_in=$2
left=$3
right=$4

tot_lines=$(wc -l $file_in | awk '{print $1}')
tot_lines=$((tot_lines+1))
width=1

# FIXME: use log base 10
if [  $tot_lines -ge 10 ] ; then
    width=2
fi
if [  $tot_lines -ge 100 ] ; then
    width=3
fi
if [  $tot_lines -ge 1000 ] ; then
    width=4
fi
if [  $tot_lines -ge 10000 ] ; then
    width=5
fi
if [  $tot_lines -ge 100000 ] ; then
    width=6
fi
if [  $tot_lines -ge 1000000 ] ; then
    width=7
fi


for n in $(seq 1 ${max:=1}) ; do
    if [ $n -eq 1 ] ; then
        from=1
    else
        from=$((tot_lines * (n-1) / max +1))
    fi
    to=$((tot_lines*n/max))
    if [ $n -eq $max ] ; then
        to=$tot_lines
    fi

    if [ -v use_stdin ] ; then
        sed -n "${from},${to}p" $file_in | bash -c "$left $right" &
    else
        bash -c "$left <(sed -n \"${from},${to}p\" $file_in) $right" &
    fi

    parent=$!
    printf "lines %${width}d to %${width}d: process started, PID=%d\n" "$from" "$to" "$!" 1>&2
done
echo "PPID=$$" 1>&2
echo "waiting for jobs to finish" 1>&2
wait