# stdin:    abs_path per line
# stdout:   rel_path:1:x per line

BEGIN {
    OFS = ":"
}

{
    "realpath --relative-base " cwd " '" $0 "' 2>/dev/null" | getline path
    $1 = path
    $2 = 1
    $3 = "x"
    print $0
}
