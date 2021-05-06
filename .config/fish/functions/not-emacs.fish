# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.Q4iJZw/not-emacs.fish @ line 1
function not-emacs
	test $TERM != dumb;and test -z "$EMACS"
end
