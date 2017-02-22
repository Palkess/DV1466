#!/bin/bash

# Page scanner - Scans the given domain for href-tags

function help { # Might connect to actual command later, focus on other scripts now
  echo "Script1 is a page scanner that downloads the given url, searches for hrefs-tags and present their values in a structured fashion."
  echo "Usage: ./script1.bash <DOMAIN> <URL>"
  echo "Ex. ./script1.bash mechani.se /"
  echo ""
  echo "Commands:"
  echo "-h,--help                                             Displays helptext"
}

DOMAIN=$1

URL=$2

SOURCE=$(curl -s $DOMAIN$URL) # Get the source from our given parameters, keep it silent to avoid annoying output

STR=""

for i in $(echo $SOURCE | grep -Po '(?<=href=")[^"]*' ); do # Get all the href-tags value and loop through
  if [[ $i == *"$DOMAIN"* ]] || [[ $i != "http"* ]]; then # Only save the records that is within the domain
    TARGETDOMAIN=$DOMAIN
    if [[ $i == "/"* ]]; then # ------------------------------------------------------------------------------ May need to revisit this since DOMAIN is accepted as a href-value
      TARGETURL=$i
    else
      TARGETURL="/$i"
    fi
    STR="$STR$DOMAIN $URL $TARGETDOMAIN $TARGETURL\n"
  fi
done

echo -e $STR
