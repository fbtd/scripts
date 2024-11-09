#!/usr/bin/env -S jq --slurp --raw-output -f
# old usage: cargo run --message-format json-diagnostic-rendered-ansi | jq -f nvql_cargo.jq --slurp -r > $NVIM_FILE_LIST
# new usage: cargo run --message-format json-diagnostic-rendered-ansi | ./nvql_cargo.jq > $NVIM_FILE_LIST
# prints the original rendered message to stderr and a vimgrep compatible string to stdout

def level_to_priority(level):
    if level == "error" then 0
    elif level == "warning" then 1
    else 2 end;

map(
    (.message.rendered | stderr | empty),
    (
        select(.message."$message_type" == "diagnostic") |
        select(.message.spans | length > 0) |
        {
            priority:   level_to_priority(.message.level),
            file:       .message.spans[0].file_name,
            line:       .message.spans[0].line_start,
            message:    ( "(" + .message.level + ") " + .message.message)
        }
    )
)
| sort_by(.priority) | .[] | [ .file, .line, .message ] | join(":")
