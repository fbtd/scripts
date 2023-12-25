# scripts
## xargs_split_files.sh
```
xargs_split_files [-sd] N_THREADS FILE_IN COMMAND_LEFT [COMMAND_RIGHT]
splits the content of FILE_IN (linewise) in N_THREADS sections and runs 'COMMAND_LEFT parital_FILE_IN COMMAND_RIGHT &' on each section
    -h: show this help
    -s: pass the file section as stdin to the command
    -d: dry run *NOT IMPLEMENTED*
    N_THREADS: max number of threads to use
    FILE_IN: file to split
    COMMAND: command to run on each file section
```
