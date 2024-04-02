#!/bin/bash

OLLAMAMODEL="mistral"

# check if ollama is installed
if ! [ -x "$(command -v ollama)" ]; then
  echo 'Error: ollama is not installed. Get it from https://ollama.com/' >&2
  exit 1
fi

# check if git is installed
if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi

# check if anything is staged
if [ -z "$(git status --porcelain)" ]; then
  echo 'No changes to commit.' >&2
  exit 1
fi

STATUS=$(git status -v)

ollamacommitmsg() {
  OLLAMAMSG="
  Imagine being a developer, you just wrote some code and you're ready to commit 
  it. You run 'git status -v' and see the following changes. Summerize the 
  changes as a commit message that could be used to commit these changes. 
  Imperative writing.

  $STATUS
  "

  # feed the changes to ollama using git status -v
  OLLAMAMESSAGE=$(echo $OLLAMAMSG | ollama run $OLLAMAMODEL)

  # remove eventual "Commit message:" string from the OLLAMAMESSAGE
  OLLAMAMESSAGE=$(echo $OLLAMAMESSAGE | sed 's/Commit message://g')

  # echo the OLLAMAMESSAGE
  echo $OLLAMAMESSAGE
}

ollamacommitmsg

# Exit the script with a success status
exit 0