#!/bin/bash

# Page scanner - Scans the given domain for href-tags

function help { # A little help for those who are lost
  echo "Script1 is a page scanner that downloads the given url, searches for hrefs-tags and present their values in a structured fashion."
  echo "Usage: ./script1.bash <DOMAIN> <URL>"
  echo "Ex. ./script1.bash mechani.se /"
  echo ""
  echo "Commands:"
  echo "-h,--help                                             Displays helptext"
}

if [ $1 == "-h" ] || [ $1 == "--help" ]; then # Handles helptext
  help
  exit 0
fi

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
    if [[ $i == ".."* ]]; then # Replaces '..' to '/unix' to handle relative paths
      i=${i#..}
      i="/unix$i"
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
