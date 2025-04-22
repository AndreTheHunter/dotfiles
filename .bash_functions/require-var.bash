require-var() {
  local var errors
  errors=()
  for var in "$@"; do
    if ! [[ -v "$var" ]]; then
      errors+=("$var")
    fi
  done
  if [ "${#errors[@]}" -gt 0 ]; then
    echo -n 'Undeclared variable' >&2
    if [ "${#errors[@]}" -gt 1 ]; then
      echo -n 's' >&2
    fi
    echo -n ': ' >&2
    join-by ', ' "${errors[@]}" >&2
    exit 1
  fi
}
