#!/usr/bin/env bash

set -euo pipefail

main_branch=$(git remote show origin | awk '/HEAD branch/ {print $NF}')
main_branch_escaped=$(printf '%s' "$main_branch" | sed 's/[.$+(){}|^*?]/\\&/g')
git fetch && git branch --merged "origin/$main_branch" | grep -vE "^\s*(\*|\+|($main_branch_escaped$))" | xargs -n 1 git branch -d || true
