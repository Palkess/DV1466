#!/bin/bash

# Page scanner - Scans the given domain for href-tags

DOMAIN=$1

URL=$2

SOURCE=$(curl -s $DOMAIN$URL) # Get the source from our given parameters, keep it silent to avoid annoying output

STR=""

for i in $(echo $SOURCE | grep -Po '(?<=href=")[^"]*' ); do # Get all the href-tags value and loop through
  if [[ $i == *"$DOMAIN"* ]] || [[ $i != "http"* ]]; then # Only save the records that is within the domain
    TARGETDOMAIN=$DOMAIN
    if [[ $i == "/"* ]]; then
      TARGETURL=$i
    else
      TARGETURL="/$i"
    fi
    STR="$STR$DOMAIN $URL $TARGETDOMAIN $TARGETURL\n"
  fi
done

echo -e $STR
