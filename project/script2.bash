#!/bin/bash

# Dispatch loop - Take the structured output from our Page scanner and loop through them again with Page scanner

$(./script1.bash mechani.se /unix/public/cw4a.html > result)

STR=$(cat result)

VISITED_URLS="" # Holds our visited urls
OUTPUT=""

while read -r line; do # Process every line
  read -a fields <<< "${line}" # Split the line into an array

  if [[ ${fields[3]} == *".html" ]] && [[ $VISITED_URLS != *${fields[3]}* ]]; then # Ignore if it's not a html-file or if we already scanned it
    $(./script1.bash ${fields[2]} ${fields[3]} >> result) # Append the output into our result-file
  fi
done <<< "$STR"
