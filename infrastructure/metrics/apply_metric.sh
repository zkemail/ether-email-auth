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

# Extract the metric name using jq
METRIC_NAME=$(jq -r '.name' "$FILE_NAME")

# Check if jq was successful
if [ -z "$METRIC_NAME" ]; then
  echo "Error: Could not extract metric name from '$FILE_NAME'."
  exit 1
fi

# Apply the metric using gcloud
gcloud logging metrics create "$METRIC_NAME" --config-from-file="$FILE_NAME"

# Check if gcloud was successful
if [ $? -eq 0 ]; then
  echo "Metric '$METRIC_NAME' applied successfully."
else
  echo "Error applying metric '$METRIC_NAME'."
  exit 1
fi