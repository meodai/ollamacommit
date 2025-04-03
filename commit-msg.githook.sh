#!/bin/bash
# Git pre-commit hook for Ollama-powered commit messages

# Ensure we can interact with the user terminal
exec < /dev/tty

# Check if this is a commit the user explicitly wants Ollama to handle
if ! grep -q '^ollama' "$1"; then
  # Not an Ollama commit request, exit silently
  exit 0
fi

# Check if "short" option is requested
if grep -q '^ollama.*short' "$1"; then
  SHORT_OPTION="short"
else
  SHORT_OPTION=""
fi

# Get the path to the ollamacommit script relative to this hook
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OLLAMA_SCRIPT="$SCRIPT_DIR/../ollamacommit.sh"

# Check if the ollamacommit script exists and is executable
if [ ! -x "$OLLAMA_SCRIPT" ]; then
  echo "Error: ollamacommit.sh script not found or not executable at $OLLAMA_SCRIPT"
  echo "Please ensure the script exists and has execute permissions."
  exit 1
fi

# Let the user know what's happening
echo "Generating AI-powered commit message..."

# Generate the commit message
result="$(bash "$OLLAMA_SCRIPT" "$SHORT_OPTION")" 
status=$?

# Check if the script ran successfully
if [ $status -ne 0 ]; then
  echo "Error: Failed to generate commit message. Do you have Ollama installed?"
  echo "You can continue with your own message below."
  echo "Enter commit message:"
  read -r custom_message
  echo "$custom_message" > "$1"
  exit 0
fi

# Print the generated message with some formatting
echo -e "\n--- Generated Commit Message ---"
echo "$result"
echo -e "-------------------------------\n"

# Ask the user if they're happy with the message
echo "Is this commit message acceptable? (y/n/e to edit):"
read -r response

case "$response" in
  y|Y)
    # Use the generated message directly
    echo "$result" > "$1"
    ;;
  e|E)
    # Let the user edit the generated message
    echo "Edit the message (original is shown as starting point):"
    read -r -e -i "$result" edited_message
    echo "$edited_message" > "$1"
    ;;
  *)
    # Let the user enter a completely new message
    echo "Enter your own commit message:"
    read -r custom_message
    echo "$custom_message" > "$1"
    ;;
esac

exit 0