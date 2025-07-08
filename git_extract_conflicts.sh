#!/bin/bash

LOCAL_TMP="./.local_tmp"
mkdir -p $LOCAL_TMP
git diff --name-only --diff-filter=U | while IFS= read -r file; do
    base=$(basename "$file")
    ext=${base##*.}
    git show ":1:$file" > "${LOCAL_TMP}/${base}.base.${ext}"
    git show ":2:$file" > "${LOCAL_TMP}/${base}.ours.${ext}"
    git show ":3:$file" > "${LOCAL_TMP}/${base}.theirs.${ext}"
done
