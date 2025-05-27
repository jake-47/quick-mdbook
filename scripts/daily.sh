#!/bin/bash

DATE=$(date +%Y-%m-%d)

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Error: Not in a git repository"
  exit 1
fi

# Stash changes if any exist
STASHED=false
if ! git diff --quiet || ! git diff --staged --quiet; then
  echo "Stashing local changes..."
  git stash push -m "temp-stash-$DATE"
  STASHED=true
fi

if ! git pull --rebase origin main; then
  echo "Rebase failed - resolve conflicts manually"
  if [ "$STASHED" = true ]; then
    echo "Your changes are stashed. Run 'git stash pop' to restore them."
  fi
  exit 1
fi

# Pop stash if we stashed
if [ "$STASHED" = true ]; then
  echo "Restoring stashed changes..."
  git stash pop
fi

git add -A

LAST_COMMIT_MSG=$(git log -1 --pretty=format:"%s" 2>/dev/null)
if [[ "$LAST_COMMIT_MSG" == "$DATE"* ]]; then
  git commit --amend --no-edit
else
  git commit -m "$DATE"
fi

git push --force-with-lease origin main