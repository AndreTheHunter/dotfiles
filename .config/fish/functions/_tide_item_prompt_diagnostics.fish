function _tide_item_prompt_diagnostics
    set -l prompt_started_ns $_prompt_diagnostics_prompt_started_ns
    if test -z "$prompt_started_ns"
        set prompt_started_ns (date +%s%N)
    end

    set -l elapsed (math (date +%s%N) - $prompt_started_ns)
    set -l render_ms (math -s0 "$elapsed / 1000000")
    set -l startup_ms $_prompt_diagnostics_startup_ms
    if test -z "$startup_ms"
        set -l startup_elapsed (math (date +%s%N) - $_prompt_diagnostics_started_ns)
        set startup_ms (math -s0 "$startup_elapsed / 1000000")
    end
    set -l label (string join '' 'boot ' $startup_ms 'ms render ' $render_ms 'ms')
    _tide_print_item time $label
end