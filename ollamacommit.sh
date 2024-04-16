#!/bin/bash

OLLAMAMODEL="mistral"

# check if ollama is installed
if ! [ -x "$(command -v ollama)" ]; then
  echo 'Error: ollama is not installed. Get it from https://ollama.com/' >&2
  exit 1
fi

STATUS=$(git show)

ollamacommitmsg() {
  makeitshortstr='';
  if [ -n "$1" ]; then
    makeitshortstr='make it short';
  fi

  OLLAMAMSG="
  Imagine being a developer, you just wrote some code and you're ready to commit 
  it. You run 'git show' and see the following changes. Summarize the 
  changes as a commit message that could be used to commit these changes. 
  Imperative writing. Do not add the code changes themselves.
  
  $makeitshortstr

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