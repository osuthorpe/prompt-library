#!/bin/bash

# Directory containing prompt YAML files
PROMPT_DIR="prompts/"
OUTPUT_FILE="tools.json"

# Gather all YAML files and count them
FILES=($PROMPT_DIR*.yaml)
TOTAL_FILES=${#FILES[@]}

# Initialize the tools JSON array
echo "[" > $OUTPUT_FILE

# Function to display a progress bar
show_progress() {
  local progress=$((100 * $1 / $TOTAL_FILES))
  printf "\rProcessing: [%-50s] %d%% (%d/%d)" \
    "$(printf '#%.0s' $(seq 1 $((progress / 2))))" \
    "$progress" "$1" "$TOTAL_FILES"
}

# Iterate over all YAML files
for i in "${!FILES[@]}"; do
  FILE="${FILES[$i]}"
  FILE_NAME=$(basename "$FILE")

  # Display the file being processed
  echo "Processing file: $FILE_NAME"

  # Extract metadata from the YAML file
  ID=$(awk '/^id:/ {print $2}' "$FILE")
  DESCRIPTION=$(awk '/^description: >-/,/^model:/' "$FILE" | tail -n +2 | sed '/^$/d' | tr '\n' ' ' | sed 's/ *$//')

  # Start building the tool JSON
  TOOL="{"
  TOOL+="\"name\": \"$ID\","
  TOOL+="\"description\": \"$DESCRIPTION\","
  TOOL+="\"parameters\": {\"type\": \"object\", \"properties\": {"

  # Extract variables
  VARIABLES=$(awk '/^variables:/,/^prompt:/' "$FILE" | grep '^[[:space:]]*[a-zA-Z0-9_]\+:')

  if [[ -n "$VARIABLES" ]]; then
    echo "$VARIABLES" | while read -r LINE; do
      VAR_NAME=$(echo "$LINE" | awk -F: '{print $1}' | xargs)
      VAR_DESC=$(awk "/$VAR_NAME:/{flag=1;next}/^[[:space:]]*[a-zA-Z0-9_]\+:/{flag=0}flag" "$FILE" | grep 'desc:' | sed 's/desc: //' | xargs)
      VAR_TYPE=$(awk "/$VAR_NAME:/{flag=1;next}/^[[:space:]]*[a-zA-Z0-9_]\+:/{flag=0}flag" "$FILE" | grep 'type:' | sed 's/type: //' | xargs)
      VAR_REQUIRED=$(awk "/$VAR_NAME:/{flag=1;next}/^[[:space:]]*[a-zA-Z0-9_]\+:/{flag=0}flag" "$FILE" | grep 'required:' | sed 's/required: //' | xargs)

      TOOL+="\"$VAR_NAME\": {"
      TOOL+="\"type\": \"$VAR_TYPE\","
      TOOL+="\"description\": \"$VAR_DESC\""
      if [[ "$VAR_REQUIRED" == "true" ]]; then
        TOOL+=",\"required\": true"
      fi
      TOOL+="},"
    done
    # Remove trailing comma
    TOOL=$(echo "$TOOL" | sed 's/,$//')
  fi

  # Close parameters
  TOOL+="}}"

  # Close tool JSON
  TOOL+="},"

  # Append to the tools file
  echo "$TOOL" >> $OUTPUT_FILE

  # Update progress bar
  show_progress $((i + 1))
done

# Remove trailing comma and close the JSON array
sed -i '' '$ s/,$//' $OUTPUT_FILE
echo "]" >> $OUTPUT_FILE

# Finish the progress bar and indicate completion
echo
echo "Tools JSON file generated successfully at $OUTPUT_FILE"