#!bash
# shellcheck disable=SC2239

put_default="C-v"
put_option="@put_key"

custom_clipboard_command_default=""
custom_clipboard_command_option="@put_custom_clipboard_command"

# helper functions
get_tmux_option() {
    local option="$1"
    local default_value="$2"
    local option_value
    option_value=$(tmux show-option -gqv "$option")
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

put_key() {
    get_tmux_option "$put_option" "$put_default"
}

custom_clipboard_command() {
    get_tmux_option "$custom_clipboard_command_option" "$custom_clipboard_command_default"
}

command_exists() {
    local command="$1"
    type "$command" >/dev/null 2>&1
}

get_clipboard_command() {
    if [ -n "$(custom_clipboard_command)" ]; then
        custom_clipboard_command
    elif command_exists "pbpaste"; then
        if command_exists "reattach-to-user-namespace"; then
            echo "reattach-to-user-namespace pbpaste"
        else
            echo "pbpaste"
        fi
    elif command_exists "powershell.exe"; then
        echo "powershell.exe -Command Get-Clipboard"
    elif command_exists "wl-paste"; then # wl-clipboard: Wayland clipboard utilities
        echo "wl-paste --no-newline"
    elif command_exists "xclip"; then
        echo "xclip -out -selection clipboard"
    elif command_exists "getclip"; then # cygwin clipboard command
        echo "getclip"
    fi
}
