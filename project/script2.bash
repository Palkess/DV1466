#!/bin/bash

# Dispatch loop - Take the structured output from our Page scanner and loop through them again with Page scanner

$(./script1.bash mechani.se /unix/public/cw4a.html > worklist.txt)

STR=$(cat worklist.txt)

VISITED_URLS="" # Holds our visited urls
OUTPUT=""

while read -r line; do
  read -a fields <<< "${line}"

  if [[ ${fields[3]} == *".html" ]] && [[ $VISITED_URLS != *${fields[3]}* ]]; then # ---------------------- Check dupes in output
    $(./script1.bash ${fields[2]} ${fields[3]} >> worklist.txt)
  fi
done <<< "$STR"
