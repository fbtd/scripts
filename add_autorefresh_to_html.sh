#!/usr/bin/env bash

# stdin: HTML page
# writes page.html or $1.html containing a script to autopdate the page on change


SCRIPT="<script>
let lastHead = '';
async function checkForChanges() {
    var p = await fetch('page.html');
    var t = await p.text();
    var currentHead = t.split('\\n')[0];
    if (lastHead === '') lastHead = currentHead;
    else if (lastHead !== currentHead) {
        console.log('REFRESH TIME');
        location.reload();
        lastHead = currentHead;
    }
}
setInterval(checkForChanges, 1000);
</script>
"

tmp=$(mktemp) || exit 1
cat > "$tmp"

{
    echo "<!-- $RANDOM $RANDOM -->"
    sed '/<\/html>/ Q' "$tmp"
    echo "$SCRIPT"
    sed -n '/<\/html>/,$ p' "$tmp"
} > page.html

rm "$tmp"
