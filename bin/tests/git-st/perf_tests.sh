#!/usr/bin/env bash

# Ensure git-st is in PATH
export PATH="$HOME/bin:$PATH"
REPO_BASE="$HOME/bin/tests/git-st/repos"

echo "=== Performance Test: No Submodules ==="
cd "$REPO_BASE/no-submodules"
hyperfine --warmup 5 'git status' 'git-st'

echo ""
echo "=== Performance Test: With Submodules (Nested) ==="
cd "$REPO_BASE/with-submodules"
hyperfine --warmup 5 'git status' 'git-st'

echo ""
echo "=== Performance Test: Many Submodules (20) ==="
cd "$REPO_BASE/many-submodules"
hyperfine --warmup 5 'git status' 'git-st'
