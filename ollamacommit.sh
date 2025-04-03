#!/bin/bash

# Use environment variable if set, otherwise default to mistral
OLLAMA_MODEL="${OLLAMACOMMITMODEL:-mistral}"

# Check if ollama is installed
if ! command -v ollama &> /dev/null; then
  echo 'Error: ollama is not installed. Get it from https://ollama.com/' >&2
  exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
  echo 'Error: not inside a git repository.' >&2
  exit 1
fi

# Get staged changes
STATUS=$(git diff --staged)
if [ -z "$STATUS" ]; then
  echo 'Warning: No staged changes found. Did you run "git add" to stage your changes?' >&2
  exit 1
fi

ollamacommitmsg() {
  make_it_short_str=''
  if [ -n "$1" ]; then
    make_it_short_str='Your response must be brief, 50 characters or less if possible.'
  fi

  OLLAMA_MSG="
  Imagine being a senior developer writing a Git commit message.

  Rules for the commit message:
  - Use imperative tense (e.g., 'Add feature' not 'Added feature')
  - Be specific but concise
  - Focus on WHY and WHAT, not HOW
  - Start with a capital letter, no period at end
  - Don't exceed 72 characters per line
  - Don't make any suggestions, just write the message
  $make_it_short_str

  Below are the staged changes from 'git diff --staged'. 
  Write ONLY the commit message, nothing else:

  $STATUS
  "

  # Feed the changes to ollama
  OLLAMA_MESSAGE=$(echo "$OLLAMA_MSG" | ollama run "$OLLAMA_MODEL")

  # Remove eventual "Commit message:" string from the output
  OLLAMA_MESSAGE=$(echo "$OLLAMA_MESSAGE" | sed 's/Commit message://g')

  # Return the message
  echo "$OLLAMA_MESSAGE"
}

ollamacommitmsg "$1"

exit 0