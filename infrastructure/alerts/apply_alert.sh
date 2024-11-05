#!/bin/bash

# Check if a file name is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <file_name>"
  exit 1
fi

FILE_NAME=$1

# Check if the file exists
if [ ! -f "$FILE_NAME" ]; then
  echo "Error: File '$FILE_NAME' does not exist."
  exit 1
fi

# Extract the display name from the JSON file
DISPLAY_NAME=$(jq -r '.displayName' "$FILE_NAME")

# Create the alert policy using gcloud
gcloud alpha monitoring policies create --policy-from-file="$FILE_NAME"

# Check if gcloud was successful
if [ $? -eq 0 ]; then
  echo "Alert policy '$DISPLAY_NAME' applied successfully."
else
  echo "Error applying alert policy '$DISPLAY_NAME'."
  exit 1
fi