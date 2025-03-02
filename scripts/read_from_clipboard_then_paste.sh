#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPERS_DIR="$CURRENT_DIR"

# shellcheck source=scripts/helpers.sh
source "${HELPERS_DIR}/helpers.sh"

tmux load-buffer <(eval "$(get_clipboard_command)") \; paste-buffer -p
