#!/usr/bin/env bats

setup() {
    export PATH="/Users/andre/bin:$PATH"
    TEST_DIR="$(mktemp -d)"
    export HOME="$TEST_DIR/home"
    mkdir -p "$HOME"

    STANDARD_REPO="$TEST_DIR/standard-repo"
    mkdir -p "$STANDARD_REPO"
    git init -q "$STANDARD_REPO"
    git -C "$STANDARD_REPO" config user.name Test
    git -C "$STANDARD_REPO" config user.email test@example.com
    printf "standard\n" > "$STANDARD_REPO/.dotfile"
    git -C "$STANDARD_REPO" add .dotfile
    git -C "$STANDARD_REPO" commit -qm "Add standard dotfile"

    git init --bare -q "$HOME/.dotfiles-secret"
    DOTFILES_GIT=(git --git-dir="$HOME/.dotfiles-secret" --work-tree="$HOME")
    "${DOTFILES_GIT[@]}" config user.name Test
    "${DOTFILES_GIT[@]}" config user.email test@example.com

    printf "current\n" > "$HOME/.current-dotfile"
    "${DOTFILES_GIT[@]}" add .current-dotfile
    "${DOTFILES_GIT[@]}" commit -qm "Add current dotfile"

    printf "history\n" > "$HOME/.history-dotfile"
    "${DOTFILES_GIT[@]}" add .history-dotfile
    "${DOTFILES_GIT[@]}" commit -qm "Add history dotfile"
    "${DOTFILES_GIT[@]}" rm -q .history-dotfile
    "${DOTFILES_GIT[@]}" commit -qm "Delete history dotfile"
}

teardown() {
    rm -rf "$TEST_DIR"
}

run_with_timeout() {
    python3 - "$@" <<'PY'
import os
import subprocess
import sys

cmd = sys.argv[1:]

try:
    result = subprocess.run(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        timeout=5,
        env=os.environ.copy(),
    )
    if result.stdout:
        sys.stdout.write(result.stdout)
    raise SystemExit(result.returncode)
except subprocess.TimeoutExpired as error:
    output = error.stdout or ""
    if isinstance(output, bytes):
        output = output.decode()
    if output:
        sys.stdout.write(output)
    sys.stderr.write("TIMEOUT\n")
    raise SystemExit(124)
PY
}

install_sleepy_post_checkout_hook() {
    local hook_path="$1"

    cat > "$hook_path" <<'EOF'
#!/bin/sh
touch "$HOME/post-checkout-fired"
sleep 10
EOF
    chmod +x "$hook_path"
}

@test "plain git restore returns promptly under a tty" {
    rm "$STANDARD_REPO/.dotfile"

    run run_with_timeout script -q /dev/null bash -lc "cd '$STANDARD_REPO' && git restore -- .dotfile"

    [ "$status" -eq 0 ]
    [ -f "$STANDARD_REPO/.dotfile" ]
}

@test ".s restore returns promptly under a tty" {
    rm "$HOME/.current-dotfile"

    run run_with_timeout script -q /dev/null fish -lc "source /Users/andre/.config/fish/functions/.s.fish; cd \$HOME; .s restore -- .current-dotfile"

    [ "$status" -eq 0 ]
    [ -f "$HOME/.current-dotfile" ]
}

@test ".s restore-deleted restores a currently deleted file promptly under a tty" {
    rm "$HOME/.current-dotfile"

    run run_with_timeout script -q /dev/null fish -lc "source /Users/andre/.config/fish/functions/.s.fish; cd \$HOME; .s restore-deleted .current-dotfile"

    [ "$status" -eq 0 ]
    [ -f "$HOME/.current-dotfile" ]
}

@test ".s restore-deleted restores a file deleted in history promptly under a tty" {
    [ ! -e "$HOME/.history-dotfile" ]

    run run_with_timeout script -q /dev/null fish -lc "source /Users/andre/.config/fish/functions/.s.fish; cd \$HOME; .s restore-deleted .history-dotfile"

    [ "$status" -eq 0 ]
    [ -f "$HOME/.history-dotfile" ]
}

@test "plain git restore triggers post-checkout hooks" {
    install_sleepy_post_checkout_hook "$STANDARD_REPO/.git/hooks/post-checkout"
    rm "$STANDARD_REPO/.dotfile"

    run run_with_timeout script -q /dev/null bash -lc "cd '$STANDARD_REPO' && git restore -- .dotfile"

    [ "$status" -eq 124 ]
    [ -e "$HOME/post-checkout-fired" ]
}

@test ".s restore passes through post-checkout hooks" {
    install_sleepy_post_checkout_hook "$HOME/.dotfiles-secret/hooks/post-checkout"
    rm "$HOME/.current-dotfile"

    run run_with_timeout script -q /dev/null fish -lc "source /Users/andre/.config/fish/functions/.s.fish; cd \$HOME; .s restore -- .current-dotfile"

    [ "$status" -eq 124 ]
    [ -e "$HOME/post-checkout-fired" ]
}

@test ".s restore-deleted bypasses post-checkout hooks for current deletions" {
    install_sleepy_post_checkout_hook "$HOME/.dotfiles-secret/hooks/post-checkout"
    rm "$HOME/.current-dotfile"

    run run_with_timeout script -q /dev/null fish -lc "source /Users/andre/.config/fish/functions/.s.fish; cd \$HOME; .s restore-deleted .current-dotfile"

    [ "$status" -eq 0 ]
    [ -f "$HOME/.current-dotfile" ]
    [ ! -e "$HOME/post-checkout-fired" ]
}

@test ".s restore-deleted bypasses post-checkout hooks for history restores" {
    install_sleepy_post_checkout_hook "$HOME/.dotfiles-secret/hooks/post-checkout"

    [ ! -e "$HOME/.history-dotfile" ]

    run run_with_timeout script -q /dev/null fish -lc "source /Users/andre/.config/fish/functions/.s.fish; cd \$HOME; .s restore-deleted .history-dotfile"

    [ "$status" -eq 0 ]
    [ -f "$HOME/.history-dotfile" ]
    [ ! -e "$HOME/post-checkout-fired" ]
}
