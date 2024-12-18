#!/bin/sh
exec < /dev/tty

if ! grep '^ollama' "$1"
then
  exit 0
fi

# read the std input
echo 'making up a commit message for you',
result="$(bash ./ollamacommit.sh)" 
echo "$result"
echo 'is this commit message ok? (y/n)'

read line

if [ "$line" = "y" ]; then
  echo "$result" > "$1"
else
  echo 'please enter a commit message'
  read line
  echo "$line" > "$1"
fi