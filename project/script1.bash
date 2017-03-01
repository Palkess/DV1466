#!/bin/bash

# Page scanner - Scans the given domain for href-tags and outputs in a structured fashion

if [ -z "$1" ] || [ -z "$2" ]; then # Handles missing args
  echo "Missing arguments."
  help
  exit 1
fi

DOMAIN=$1

URL=$2

SOURCE=$(curl -s "$DOMAIN$URL") # Get the source from our given parameters, keep it silent to avoid annoying output

STR=""
STORED=""

for i in $(echo "$SOURCE" | grep -Po '(?<=a href=")[^"]*' ); do # Get all the a href-tags value and loop through
  if [[ $i != "http"* ]] && [[ $i != "mailto"* ]]; then # Only save the records that is within the domain
    TARGETDOMAIN=$DOMAIN
    if [[ $i == "../"* ]]; then # Handle relative paths
      IFS=/ read -a levels <<< $i
      IFS=/ read -a URL_LEVELS <<< $URL
      NR_OF_URL_LEVELS=${#URL_LEVELS[@]}
      result=""

      if [[ $(echo "$i" | grep -o '\.\.\/' | wc -l) -eq $(expr ${#URL_LEVELS[@]} - 2) ]] || [[ $(echo "$i" | grep -o '\.\.\/' | wc -l) -gt $(expr ${#URL_LEVELS[@]} - 2) ]]; then
        for (( level = 0; level < ${#levels[@]}; level++ )); do
          if [[ ${levels[$level]} != ".." ]]; then
            result="$result${levels[$level]}"
            if [[ $level < $(expr ${#levels[@]} - 1) ]]; then
              result="$result/"
            fi
          fi
        done
      else
        for (( level = 0; level < ${#levels[@]}; level++ )); do
          if [[ ${levels[$level]} == ".." ]]; then
            levels[$level]=${URL_LEVELS[$(expr $level + 1)]}
          fi
          result="$result${levels[$level]}"
          if [[ $level < $(expr ${#levels[@]} - 1) ]]; then
            result="$result/"
          fi
        done
      fi
      i="/$result"
    fi

    if [[ $i != *"/"* ]]; then # Handle local paths to files
      i="${URL%\/*}/$i"
    fi

    if [[ $i == *"?"* ]]; then # Removes any parameters in the path if it has any
      i=${i%\?*}
    fi

    if [[ $STORED != *"$i"* ]]; then # If it's already been stored in the output, we skip it
      TARGETPATH=$i
      STR="$STR$DOMAIN $URL $TARGETDOMAIN $TARGETPATH \n"
      STORED="$STORED$i"
    fi
  fi
done

printf "$STR"
