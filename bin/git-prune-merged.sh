#!/usr/bin/env bash

# Deletes local branches that have already been merged into the
# remote's default branch (e.g. main/master), keeping the working
# tree tidy after PRs are merged.
#
# The default branch is detected automatically. The remote is
# expected to be named "origin" (the standard convention).
#
# Skips the current branch and any branch checked out in another
# worktree, since these can't be safely deleted anyway.
#
# Usage: git prune-merged

set -euo pipefail

main_branch=$(git remote show origin | awk '/HEAD branch/ {print $NF}')
main_branch_escaped=$(printf '%s' "$main_branch" | sed 's/[.$+(){}|^*?]/\\&/g')
git fetch && git branch --merged "origin/$main_branch" | grep -vE "^\s*(\*|\+|($main_branch_escaped$))" | xargs -n 1 git branch -d || true
