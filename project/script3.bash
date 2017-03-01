#!/bin/bash

# Generates a Graphviz-svg from our result-file

echo "digraph result {" > result.dot # Begin our description of the digraph

while read -r line; do # Process every line
  read -a fields <<< "${line}" # Split the line into an array

  echo "\"${fields[1]}\" -> \"${fields[3]}\"" >> result.dot # Append the description with a new connection for each line

done <<< "$(cat result)"

echo "}" >> result.dot # Close the description
