#!/bin/bash

# File to update
INDEX_FILE="index.yaml"
PROMPT_DIR="prompts/"
FILES=($PROMPT_DIR*.yaml) # Array of YAML files
TOTAL_FILES=${#FILES[@]} # Total number of files

# Header for the index file
echo "prompts:" > $INDEX_FILE

# Function to display a progress bar
show_progress() {
  local progress=$((100 * $1 / $TOTAL_FILES))
  printf "\rProcessing: [%-50s] %d%% (%d/%d)" \
    "$(printf '#%.0s' $(seq 1 $((progress / 2))))" \
    "$progress" "$1" "$TOTAL_FILES"
}

# Iterate through YAML files in the prompts directory
for i in "${!FILES[@]}"; do
  FILE="${FILES[$i]}"

  # Display the file being processed
  echo "Processing file: $(basename "$FILE")"

  # Extract metadata using YAML-safe parsing
  ID=$(awk '/^id:/ {print $2}' "$FILE")
  DESCRIPTION=$(awk '/^description: >/,/^model:/' "$FILE" | tail -n +2 | sed '/^$/d' | tr '\n' ' ' | sed 's/ *$//')

  # Ensure ID and DESCRIPTION are not empty
  if [[ -n "$ID" && -n "$DESCRIPTION" ]]; then
    echo "  - id: $ID" >> $INDEX_FILE
    echo "    file: $(basename "$FILE")" >> $INDEX_FILE
    echo "    description: >-" >> $INDEX_FILE
    echo "      $DESCRIPTION" >> $INDEX_FILE
  else
    echo "Warning: Missing 'id' or 'description' in $(basename "$FILE")"
  fi

  # Update progress bar
  show_progress $((i + 1))
done

# New line after the progress bar
echo
echo "Index file updated successfully!"
