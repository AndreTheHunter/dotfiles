function project_delegate
    if is-executable-file run
        echo ./run
    else if test -f Justfile; or test -f justfile; or test -f mod.just
        echo just
    else if test -f Makefile; or test -f makefile
        echo make
    else if test -f build.boot
        echo boot
    else if test -f project.clj
        echo lein
    else if test -f gulpfile.js; or test -f gulpfile.babel.js
        echo gulp
    else if test -f package.json
        if test -f package-lock.json
            echo npm
        else
            echo yarn
        end
    else if test -f pom.xml
        echo mvn
    else if test -f mise.toml
        echo mise
        echo run
    else if test -d project.godot
        echo godot
    else
        set -l file (basename $PWD)
        if is-executable-file "$file.ps1"
            echo ./$file.ps1
        else if is-executable-file "$file.sh"
            echo ./$file.sh
        else if is-executable-file "$file.clj"
            echo ./$file.clj
        end
    end
end
