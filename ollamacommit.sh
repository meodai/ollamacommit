#!/bin/bash

OLLAMAMODEL="openhermes"

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

OLLAMAMSG="
Imagine being a developer, you just wrote some code and you're ready to commit it. 
You run git status and see the following changes. Summerize the changes and write a commit message.

$STATUS
"

# feed the changes to ollama using git status -v
echo "$OLLAMAMSG" | ollama run $OLLAMAMODEL

# Exit the script with a success status
exit 0
