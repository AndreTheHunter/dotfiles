function man --wraps=gman --description 'alias man gman'
    env GROFF_NO_SGR=1 MANROFFOPT=-Wbreak PAGER=cat MANPAGER=cat gman -Tutf8 $argv | less -+F -R -X
end
