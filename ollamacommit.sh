#!/bin/bash

# check if git is installed
if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi

# check if anything is staged
if [ -z "$(git status --porcelain)" ]; then
  echo 'Error: No changes to commit.' >&2
  exit 1
fi

STATUS=$(git status -v)

OLLAMAMSG="
write a short, imperative tense message that describes the change for 
the following staged changes:

$STATUS
"

# feed the changes to ollama using git status -v
echo "$OLLAMAMSG" | ollama run mistral


# Exit the script with a success status
exit 0
