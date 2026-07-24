# Test for yarn completions using actual completion engine.
#
# Each assertion spawns a fresh, fully-initialized fish shell (as if opening a new tab and
# running `reload`) instead of manually sourcing individual completion files. This matters:
# fish only autoloads completions/<cmd>.fish the first time a command has no completions
# registered yet, and carapace_init.fish registers an unconditional completion for every
# command it knows about (including yarn) as soon as it's sourced at shell startup. Manually
# sourcing completions/yarn.fish (as earlier versions of this test did) hid that failure mode,
# because it bypassed the autoload race entirely.

function __yarn_test_complete -a dir cmdline
    # TERM=dumb keeps fish from emitting vi-mode cursor-shape escape codes on
    # startup (see NOT_EMACS in .fishrc), so captured output stays plain text.
    env TERM=dumb fish -i -c "cd $dir; complete -C'$cmdline'" 2>/dev/null
end

@test "yarn: 'yarn run' lists project scripts in a fresh shell" (
    __yarn_test_complete /Users/andre/arep/am3 "yarn run " | grep -qx dev
    and echo 1; or echo 0
) = 1

@test "yarn: shorthand 'yarn <script>' lists project scripts in a fresh shell" (
    __yarn_test_complete /Users/andre/arep/am3 "yarn d" | grep -qx dev
    and echo 1; or echo 0
) = 1

@test "yarn: 'yarn run' works from a subdirectory without its own package.json" (
    __yarn_test_complete /Users/andre/arep/am3/client "yarn run " | grep -qx dev
    and echo 1; or echo 0
) = 1

@test "yarn: no package.json in the directory tree means no script completions" (
    __yarn_test_complete /tmp "yarn run " | grep -qx dev
    and echo 0; or echo 1
) = 1

@test "yarn: completions/yarn.fish is loaded at shell startup, not just on-demand" (
    env TERM=dumb fish -i -c 'functions -q __fish_yarn_print_scripts; echo $status' 2>/dev/null
) = 0
