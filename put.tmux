#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${CURRENT_DIR}/scripts"
HELPERS_DIR="${CURRENT_DIR}/scripts"

# shellcheck source=scripts/helpers.sh
source "${HELPERS_DIR}/helpers.sh"

tmux bind-key "$(put_key)" run-shell -b "$SCRIPTS_DIR/read_from_clipboard_then_paste.sh"
