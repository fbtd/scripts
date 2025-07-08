#!/usr/bin/bash
RESULTS=$1

if [ "$#" -lt 1 ]; then
    echo "usage: $0 results.json"
    exit 1
fi

BY_DURATION=${RESULTS/%.json/_by_duration.json}
jq '.results | sort_by(.duration)[] | {"input", "duration": (.duration / 1000000)}' $RESULTS > $BY_DURATION

BY_STATUS=${RESULTS/%.json/_by_status.json}
jq '.results | sort_by(.status)[] | {"input", "status"}' $RESULTS > $BY_STATUS

BY_LENGTH=${RESULTS/%.json/_by_lengths.json}
jq '.results | sort_by(.length)[] | {"input", "length"}' $RESULTS > $BY_LENGTH
