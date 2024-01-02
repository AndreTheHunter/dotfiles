#!/usr/bin/env fish
for vim in vim nvim
    eval $vim -n +PlugUpgrade +PlugUpdate +PlugClean! +qall
end
