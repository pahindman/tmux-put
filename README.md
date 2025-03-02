tmux-put
========

Paste from the system clipboard in [`tmux`](https://tmux.github.io/).

Supports:

-   Linux
-   macOS
-   Cygwin
-   Windows Subsystem for Linux (WSL)

Installing
----------

### Via TPM (recommended)

The easiest way to install `tmux-put` is via the [Tmux Plugin
Manager](https://github.com/tmux-plugins/tpm).

1.  Add plugin to the list of TPM plugins in `.tmux.conf`:

    ``` tmux
    set -g @plugin 'pahindman/tmux-put'
    ```

2.  Use <kbd>prefix</kbd>–<kbd>I</kbd> install `tmux-put`. You should now
    be able to `tmux-put` immediately.
3.  When you want to update `tmux-put` use <kbd>prefix</kbd>–<kbd>U</kbd>.

### Manual Installation

1.  Clone the repository

    ``` sh
    $ git clone https://github.com/pahindman/tmux-put ~/clone/path
    ```

2.  Add this line to the bottom of `.tmux.conf`

    ``` tmux
    run-shell ~/clone/path/put.tmux
    ```

3.  Reload the `tmux` environment

    ``` sh
    # type this inside tmux
    $ tmux source-file ~/.tmux.conf
    ```

You should now be able to use `tmux-put` immediately.

Requirements
------------

`tmux-put` relies on an external program to retrieve data from the system clipboard, and
by default will try to detect and use one of the following programs.  These programs were
chosen on a 'minimal effort' basis and may not work for all users.

If one of these defaults is not working for you then you can open an issue describing the
problem. If you know of a replacement command then you can customize the command as
described in
[Default and Preferred Clipboard Programs](#default-and-preferred-clipboard-programs)
(and open a PR to update the default).

### Linux

-   `xclip` (for X)
-   `wl-paste` from [wl-clipboard](https://github.com/bugaevc/wl-clipboard) (for Wayland)

### macOS

-   `pbpaste`

### Cygwin

-   (*optional*) `getclip` which is part of the `cygutils-extra` package.

### Windows Subsystem for Linux (WSL)

-   `powershell.exe`

Configuration
-------------

### Key bindings

The `@put_key` option sets the key bind used for pasting from the system clipboard, and
defaults to `C-v`.  The key is used with the `prefix` key, e.g. `prefix` + `C-v`.

An example of changing the key:

``` tmux
# ~/.tmux.conf

set -g @put_key 'C-]'
```

### Default and Preferred Clipboard Programs

If you need to provide a custom clipboard program then you can set
`@put_custom_clipboard_command` to force `tmux-put` to use whatever you specify.

Note that the clipboard program _must_ produce the clipboard text on `STDOUT`.

An example of using a custom clipboard program:

``` tmux
# ~/.tmux.conf

set -g @put_custom_clipboard_command 'read-from-clipboard --some-arg'
```

### Other tmux plugins

-   [tmux-yank](https://github.com/tmux-plugins/tmux-yank) - a plugin
    for copying to system clipboard. Works on MacOS, Linux and Cygwin.

### License

[MIT](LICENSE.md)
