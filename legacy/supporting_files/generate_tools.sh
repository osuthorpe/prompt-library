#!/bin/bash

# Directory containing prompt YAML files
PROMPT_DIR="./prompts/"
OUTPUT_FILE="./supporting_files/tools.json"

# Check if yq is installed
if ! command -v yq &> /dev/null
then
    echo "yq could not be found. Please install yq to proceed."
    exit
fi

# Gather all YAML files and count them
FILES=("$PROMPT_DIR"*.yaml)
TOTAL_FILES=${#FILES[@]}

# Initialize the tools JSON array
echo "[" > "$OUTPUT_FILE"

# Function to display a progress bar
show_progress() {
  local progress=$((100 * $1 / $TOTAL_FILES))
  local filled=$((progress / 2))
  local empty=$((50 - filled))
  printf "\rProcessing: ["
  printf "%0.s#" $(seq 1 $filled)
  printf "%0.s-" $(seq 1 $empty)
  printf "] %d%% (%d/%d)" "$progress" "$1" "$TOTAL_FILES"
}

# Iterate over all YAML files
for i in "${!FILES[@]}"; do
  FILE="${FILES[$i]}"
  FILE_NAME=$(basename "$FILE")
  
  # Display the file being processed
  echo "Processing file: $FILE_NAME"

  # Extract metadata using yq
  ID=$(yq e '.id' "$FILE")
  DESCRIPTION=$(yq e '.description' "$FILE" | tr '\n' ' ' | sed 's/  */ /g' | xargs)
  
  # Check if ID and DESCRIPTION are present
  if [[ -z "$ID" || -z "$DESCRIPTION" ]]; then
    echo "Warning: Missing 'id' or 'description' in $FILE_NAME"
    show_progress $((i + 1))
    continue
  fi
  
  # Extract variables and construct parameters
  VARIABLES=$(yq e '.variables' "$FILE")
  
  PARAMETERS="{\"type\": \"object\", \"properties\": {"
  REQUIRED_FIELDS=$(yq e '.variables | with_entries(select(.value.required == true)) | keys' "$FILE")
  
  # Iterate over each variable
  VAR_COUNT=$(echo "$VARIABLES" | yq e 'keys | length' -)
  for VAR in $(echo "$VARIABLES" | yq e 'keys | .[]' -); do
    VAR_TYPE=$(yq e ".variables.$VAR.type" "$FILE")
    VAR_DESC=$(yq e ".variables.$VAR.desc" "$FILE" | tr '\n' ' ' | sed 's/  */ /g' | xargs)
    VAR_REQUIRED=$(yq e ".variables.$VAR.required" "$FILE")
    
    PARAMETERS+="\"$VAR\": {"
    PARAMETERS+="\"type\": \"$VAR_TYPE\","
    PARAMETERS+="\"description\": \"$VAR_DESC\""
    
    if [[ "$VAR_REQUIRED" == "true" ]]; then
      PARAMETERS+=",\"required\": true"
    fi
    
    PARAMETERS+="},"
  done
  
  # Remove trailing comma and close properties and parameters
  PARAMETERS=$(echo "$PARAMETERS" | sed 's/,$//')
  PARAMETERS+="}}"

  # Construct the tool JSON object
  TOOL="{"
  TOOL+="\"name\": \"$ID\","
  TOOL+="\"description\": \"$DESCRIPTION\","
  TOOL+="\"parameters\": $PARAMETERS"
  TOOL+="},"

  # Append the tool to the tools.json file
  echo "$TOOL" >> "$OUTPUT_FILE"

  # Update progress bar
  show_progress $((i + 1))
done

# Remove trailing comma from the last tool and close the JSON array
sed -i '' '$ s/,$//' "$OUTPUT_FILE" # For macOS. Use 'sed -i' without quotes on Linux
echo "]" >> $OUTPUT_FILE
jq . $OUTPUT_FILE > formatted_tools.json
mv formatted_tools.json $OUTPUT_FILE

# Finish the progress bar and indicate completion
echo
echo "Tools JSON file generated successfully at $OUTPUT_FILE"
