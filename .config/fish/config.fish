# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/andre/.docker/bin"
# End of Docker Desktop section.

source "$HOME/.fishrc"

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/andre/.lmstudio/bin
# End of LM Studio CLI section



# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/Users/andre/.opam/opam-init/init.fish' && source '/Users/andre/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration
