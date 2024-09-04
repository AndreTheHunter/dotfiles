function git-debug --argument enable
    if contains $enable no false 0
        echo 'Clearing git debug env vars'
        set --erase GIT_TRACE
        set --erase GIT_CURL_VERBOSE
        set --erase GIT_SSH_COMMAND
    else
        echo 'Enabling git debug env vars'
        set --global --export GIT_TRACE 1
        set --global --export GIT_CURL_VERBOSE 1
        set --global --export GIT_SSH_COMMAND 'ssh -v'
    end
end
