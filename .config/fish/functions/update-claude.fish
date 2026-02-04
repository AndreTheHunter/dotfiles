function update-claude --wraps='brew update; and brew upgrade claude-code' --description 'alias update-claude brew update;and brew upgrade claude-code'
    brew update
    and brew upgrade claude-code $argv
end
