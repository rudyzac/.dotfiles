#!/usr/bin/env bash
#
# Symlinks the scripts in this directory into ~/.local/bin.
# ~/.local/bin should be on PATH.

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

mkdir -p ~/.local/bin

ln -sf "$script_dir/git-prune-merged.sh" ~/.local/bin/git-prune-merged

