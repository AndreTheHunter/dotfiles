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

    function __dbg_milestone -a name
        if status is-interactive
            set -l now (date +%s%N)
            set -l elapsed (math -s0 "($now - $_prompt_diagnostics_started_ns) / 1000000")
            set -l log_msg "[$elapsed ms] [pid=$fish_pid] $name"

            logger -t fish.startup "$log_msg" 2>/dev/null

            set -l log_dir "$HOME/Library/Logs/fish"
            test -d "$log_dir"; or mkdir -p "$log_dir"
            echo (date "+%Y-%m-%d %H:%M:%S") "$log_msg" >> "$log_dir/startup.log"
        end
    end

    function _prompt_diagnostics_mark_prompt --on-event fish_prompt
        set -gx _prompt_diagnostics_prompt_started_ns (date +%s%N)

        if not set -q _prompt_diagnostics_startup_ms
            set -l elapsed (math (date +%s%N) - $_prompt_diagnostics_started_ns)
            set -gx _prompt_diagnostics_startup_ms (math -s0 "$elapsed / 1000000")
            __dbg_milestone "boot_complete (boot=$_prompt_diagnostics_startup_ms ms, pwd=$PWD)"
        end
    end

    if not contains prompt_diagnostics $tide_right_prompt_items
        set -U tide_right_prompt_items $tide_right_prompt_items prompt_diagnostics
    end
end