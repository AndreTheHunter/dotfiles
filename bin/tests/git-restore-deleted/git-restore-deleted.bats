#!/usr/bin/env bats

setup() {
    # Save real home to access the script
    REAL_HOME="/Users/andre"
    export PATH="$REAL_HOME/bin:$PATH"
    
    export HOME="$BATS_TEST_TMPDIR/home"
    mkdir -p "$HOME/.bash_functions"
    
    # Mock strict.bash which is sourced by the script
    echo "set -eEuo pipefail; IFS=$'\n\t'" > "$HOME/.bash_functions/strict.bash"

    STANDARD_REPO="$BATS_TEST_TMPDIR/standard-repo"
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

    # Setup for move-detection tests (isolated repo)
    REPO_DIR="$BATS_TEST_TMPDIR/repo"
    mkdir -p "$REPO_DIR"
    cd "$REPO_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
}

teardown() {
    :
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

# Help tests
@test "shows help message with -h" {
    run git-restore-deleted -h
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage: git-restore-deleted [options] [file...]"* ]]
    [[ "$output" == *"Options:"* ]]
    [[ "$output" == *"-v, --verbose"* ]]
    [[ "$output" == *"-h, --help"* ]]
}

@test "shows help message with --help" {
    run git-restore-deleted --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage: git-restore-deleted [options] [file...]"* ]]
    [[ "$output" == *"Options:"* ]]
    [[ "$output" == *"-v, --verbose"* ]]
    [[ "$output" == *"-h, --help"* ]]
}

# Move detection tests
@test "restores a file deleted from working tree" {
    echo "content" > file.txt
    git add file.txt
    git commit -m "initial"
    rm file.txt
    
    [ ! -f file.txt ]
    run git-restore-deleted file.txt
    [ "$status" -eq 0 ]
    [ -f file.txt ]
    [ "$(cat file.txt)" = "content" ]
}

@test "restores a file deleted in history" {
    echo "content" > file.txt
    git add file.txt
    git commit -m "initial"
    git rm file.txt
    git commit -m "delete"
    
    [ ! -f file.txt ]
    run git-restore-deleted file.txt
    [ "$status" -eq 0 ]
    [ -f file.txt ]
    [ "$(cat file.txt)" = "content" ]
}

@test "skips restoration if content already exists in index (move detection)" {
    echo "unique content" > file_a.txt
    git add file_a.txt
    git commit -m "add a"
    
    # Simulate move: delete A, add B with same content
    git rm file_a.txt
    echo "unique content" > file_b.txt
    git add file_b.txt
    git commit -m "move a to b"
    
    # Now file_a.txt is deleted in history, but its content is in file_b.txt in the index
    run git-restore-deleted -v file_a.txt
    [ "$status" -eq 0 ]
    [[ "$output" == *"Skipped 'file_a.txt' (content already exists in index: file_b.txt)"* ]]
    [ ! -f file_a.txt ]
}

@test "skips restoration if same filename exists in nearby archive (heuristic)" {
    mkdir plans
    echo "plan content" > plans/test.md
    git add plans/test.md
    git commit -m "add plan"
    git rm plans/test.md
    git commit -m "delete plan"
    
    # Create archive and put the file there
    mkdir -p plans/archive
    echo "plan content modified" > plans/archive/test.md
    git add plans/archive/test.md
    
    run git-restore-deleted -v plans/test.md
    [ "$status" -eq 0 ]
    [[ "$output" == *"Skipped 'plans/test.md' (found elsewhere in index: plans/archive/test.md)"* ]]
    [ ! -f plans/test.md ]
}

@test "skips restoration if renamed in the deletion commit" {
    echo "rename content is long enough to detect similarity" > old_name.txt
    git add old_name.txt
    git commit -m "initial"
    git mv old_name.txt new_name.txt
    git commit -m "rename"
    
    run git-restore-deleted -v old_name.txt
    [ "$status" -eq 0 ]
    [[ "$output" == *"Skipped 'old_name.txt' (content already exists in index: new_name.txt)"* || "$output" == *"Skipped 'old_name.txt' (renamed to 'new_name.txt' in"* ]]
    [ ! -f old_name.txt ]
}

@test "skips if staged for deletion" {
    echo "content" > file.txt
    git add file.txt
    git commit -m "initial"
    git rm file.txt
    
    run git-restore-deleted file.txt
    [ "$status" -eq 0 ]
    [[ "$output" == *"is staged for deletion (or part of a move), skipping"* ]]
    [ ! -f file.txt ]
}

@test "skips if same filename exists elsewhere in index (arbitrary move)" {
    mkdir -p folder_a
    echo "content" > folder_a/file.txt
    git add folder_a/file.txt
    git commit -m "add file"
    
    rm folder_a/file.txt
    mkdir -p folder_b
    echo "modified content" > folder_b/file.txt
    git add folder_b/file.txt
    
    run git-restore-deleted -v folder_a/file.txt
    [ "$status" -eq 0 ]
    [[ "$output" == *"Skipped 'folder_a/file.txt' (found elsewhere in index: folder_b/file.txt)"* ]]
    [ ! -f folder_a/file.txt ]
}

@test "skips fuzzy move (content changed) if intent-to-add is used" {
    # Create a large enough file for fuzzy matching
    seq 1 100 > large.txt
    git add large.txt
    git commit -m "add large"
    
    # Move and modify slightly
    mv large.txt moved_large.txt
    seq 2 101 > moved_large.txt
    # No git add yet, only deletion in work tree
    
    # Run without intent-to-add (should NOT skip unless it uses filename heuristic)
    # Actually, it might skip because of the filename heuristic if we used the same name,
    # but here we used a different name 'moved_large.txt'.
    run git-restore-deleted large.txt
    [ "$status" -eq 0 ]
    [[ "$output" != *"skipping"* ]]
    [ -f large.txt ] # It was restored
    
    rm large.txt
    # Create the target file first
    mv moved_large.txt moved_large_2.txt
    # Now use intent-to-add
    git add -N moved_large_2.txt
    
    run git-restore-deleted -v large.txt
    [ "$status" -eq 0 ]
    [[ "$output" == *"detected as move to 'moved_large_2.txt' in work tree"* ]]
    [ ! -f large.txt ]
}

@test "handles directory restoration while skipping moved files" {
    mkdir -p docs
    echo "stay content" > docs/stay.txt
    echo "move content" > docs/move.txt
    git add docs
    git commit -m "add docs"
    
    mv docs/move.txt backup.txt
    git add backup.txt
    rm docs/stay.txt
    
    [ ! -f docs/stay.txt ]
    [ ! -f docs/move.txt ]
    [ -f backup.txt ]
    
    run git-restore-deleted -v docs
    [ "$status" -eq 0 ]
    [ -f docs/stay.txt ]
    [ ! -f docs/move.txt ]
    [[ "$output" == *"Skipped 'docs/move.txt' (content already exists in index: backup.txt)"* ]]
}

@test "skips restoration if file already exists in worktree" {
    echo "content" > existing.txt
    git add existing.txt
    git commit -m "add existing" -q
    git rm existing.txt -q
    git commit -m "delete existing" -q
    echo "current content" > existing.txt
    # Now existing.txt is untracked but present.
    
    run git-restore-deleted existing.txt
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat existing.txt)" = "current content" ]
}

@test "skips restoration if file already exists and is tracked" {
    echo "content" > tracked.txt
    git add tracked.txt
    git commit -m "add tracked" -q
    git rm tracked.txt -q
    git commit -m "delete tracked" -q
    echo "current tracked content" > tracked.txt
    git add tracked.txt
    git commit -m "re-add tracked" -q
    
    run git-restore-deleted tracked.txt
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat tracked.txt)" = "current tracked content" ]
}

@test "graceful warning for directory with no deletions" {
    mkdir -p no-deletions
    echo "content" > no-deletions/file.txt
    git add no-deletions/file.txt
    git commit -m "initial" -q
    
    run git-restore-deleted no-deletions
    [ "$status" -eq 0 ]
    [[ "$output" == *"no deletion history found for directory: no-deletions"* ]]
}

@test "skips restoration if file exists even if not matched in index" {
    echo "content" > file.txt
    git add file.txt
    git commit -m "initial" -q
    git rm file.txt -q
    git commit -m "delete" -q
    
    echo "different content" > file.txt
    # file.txt exists but is untracked and different from history
    
    run git-restore-deleted file.txt
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat file.txt)" = "different content" ]
}
