# Temporary diagnostics for intermittent shell/prompt slowdowns.
# Disable for a shell (or future tabs) with: set -gx PROMPT_DIAGNOSTICS 0
# Once the measurements are no longer useful, remove this file and
# _tide_item_prompt_diagnostics.fish.
if test "$PROMPT_DIAGNOSTICS" = 0; or test "$PROMPT_DIAGNOSTICS" = false; or test "$PROMPT_DIAGNOSTICS" = off
    if contains prompt_diagnostics $tide_right_prompt_items
        set -U tide_right_prompt_items (string match -v prompt_diagnostics $tide_right_prompt_items)
    end
else
    set -gx _prompt_diagnostics_started_ns (date +%s%N)

    function _prompt_diagnostics_mark_prompt --on-event fish_prompt
        set -gx _prompt_diagnostics_prompt_started_ns (date +%s%N)

        if not set -q _prompt_diagnostics_startup_ms
            set -l elapsed (math (date +%s%N) - $_prompt_diagnostics_started_ns)
            set -gx _prompt_diagnostics_startup_ms (math -s0 "$elapsed / 1000000")
        end
    end

    if not contains prompt_diagnostics $tide_right_prompt_items
        set -U tide_right_prompt_items $tide_right_prompt_items prompt_diagnostics
    end
end