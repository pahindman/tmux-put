#!/usr/bin/env bats

setup() {
	export HELPERS_DIR
	HELPERS_DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")/../scripts" && pwd)"
	export TEST_TMP_DIR
	TEST_TMP_DIR="$(mktemp -d)"
	export PATH="$TEST_TMP_DIR:$PATH"
	# shellcheck source=scripts/helpers.sh
	source "${HELPERS_DIR}/helpers.sh"
}

teardown() {
	rm -rf "$TEST_TMP_DIR"
}

# ============================================================================
# Tests for: get_tmux_option()
# ============================================================================

@test "get_tmux_option returns default when option is not set" {
	# Mock tmux to return empty string
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		exit 0
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	result=$(get_tmux_option "@test_option" "default_value")
	[[ "$result" == "default_value" ]]
}

@test "get_tmux_option returns actual value when option is set" {
	# Mock tmux to return a specific value
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		echo "actual_value"
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	result=$(get_tmux_option "@test_option" "default_value")
	[[ "$result" == "actual_value" ]]
}

@test "get_tmux_option returns empty when empty string from tmux" {
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		exit 0
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	result=$(get_tmux_option "@empty_option" "fallback")
	[[ "$result" == "fallback" ]]
}

@test "get_tmux_option returns empty when error from tmux" {
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		echo "error_text"
		exit 1
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	result=$(get_tmux_option "@empty_option" "fallback")
	[[ "$result" == "fallback" ]]
}

# ============================================================================
# Tests for: get_clipboard_command()
# ============================================================================

@test "get_clipboard_command returns pbpaste for macOS (without reattach)" {
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		exit 0
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	# Override command_exists to report only pbpaste
	# shellcheck disable=SC2329
	command_exists() {
		[[ "$1" == "pbpaste" ]]
	}
	export -f command_exists

	result=$(get_clipboard_command)
	[[ "$result" == "pbpaste" ]]
}

@test "get_clipboard_command returns pbpaste with reattach when both available" {
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		exit 0
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	# Override command_exists to report both available
	# shellcheck disable=SC2329
	command_exists() {
		[[ "$1" == "pbpaste" ]] || [[ "$1" == "reattach-to-user-namespace" ]]
	}
	export -f command_exists

	result=$(get_clipboard_command)
	[[ "$result" == "reattach-to-user-namespace pbpaste" ]]
}

@test "get_clipboard_command returns powershell command for Windows (WSL)" {
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		exit 0
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	# Override command_exists to report only powershell.exe
	# shellcheck disable=SC2329
	command_exists() {
		[[ "$1" == "powershell.exe" ]]
	}
	export -f command_exists

	result=$(get_clipboard_command)
	[[ "$result" == "powershell.exe -Command Get-Clipboard" ]]
}

@test "get_clipboard_command returns wl-paste for Wayland" {
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		exit 0
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	# Override command_exists to report only wl-paste
	# shellcheck disable=SC2329
	command_exists() {
		[[ "$1" == "wl-paste" ]]
	}
	export -f command_exists

	result=$(get_clipboard_command)
	[[ "$result" == "wl-paste --no-newline" ]]
}

@test "get_clipboard_command returns xclip for X11" {
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		exit 0
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	# Override command_exists to report only xclip
	# shellcheck disable=SC2329
	command_exists() {
		[[ "$1" == "xclip" ]]
	}
	export -f command_exists

	result=$(get_clipboard_command)
	[[ "$result" == "xclip -out -selection clipboard" ]]
}

@test "get_clipboard_command returns getclip for Cygwin" {
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		exit 0
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	# Override command_exists to report only getclip
	# shellcheck disable=SC2329
	command_exists() {
		[[ "$1" == "getclip" ]]
	}
	export -f command_exists

	result=$(get_clipboard_command)
	[[ "$result" == "getclip" ]]
}

@test "get_clipboard_command returns empty string when no clipboard tool found" {
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		exit 0
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	# Override command_exists to report no tools available
	# shellcheck disable=SC2329
	command_exists() {
		return 1
	}
	export -f command_exists

	result=$(get_clipboard_command)
	[[ -z "$result" ]]
}

@test "get_clipboard_command uses custom command when set" {
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		# If called for custom clipboard command option, return it
		if [[ "$3" == "@put_custom_clipboard_command" ]]; then
			echo "custom-clipboard-cmd"
		fi
		exit 0
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	# Override command_exists to avoid early exit
	# shellcheck disable=SC2329
	command_exists() {
		return 1
	}
	export -f command_exists

	result=$(get_clipboard_command)
	[[ "$result" == "custom-clipboard-cmd" ]]
}

@test "get_clipboard_command wl-paste includes --no-newline flag" {
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		exit 0
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	# shellcheck disable=SC2329
	command_exists() {
		[[ "$1" == "wl-paste" ]]
	}
	export -f command_exists

	result=$(get_clipboard_command)
	[[ "$result" == *"--no-newline"* ]]
}

@test "get_clipboard_command xclip includes selection flag" {
	cat >"$TEST_TMP_DIR/tmux" <<-'EOF'
		#!/bin/bash
		exit 0
	EOF
	chmod +x "$TEST_TMP_DIR/tmux"

	# shellcheck disable=SC2329
	command_exists() {
		[[ "$1" == "xclip" ]]
	}
	export -f command_exists

	result=$(get_clipboard_command)
	[[ "$result" == *"-selection"* ]] && [[ "$result" == *"clipboard"* ]]
}
