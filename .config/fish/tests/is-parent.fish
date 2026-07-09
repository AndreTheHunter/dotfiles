@test "is-parent / /Users" (is-parent / /Users; and echo 1; or echo 0) = 1
@test "is-parent /Users/ /Users/" (is-parent /Users/ /Users/; and echo 1; or echo 0) = 1
@test "is-parent / /" (is-parent / /; and echo 1; or echo 0) = 1
@test "is-parent // /" (is-parent // /; and echo 1; or echo 0) = 1
@test "is-parent / //" (is-parent / //; and echo 1; or echo 0) = 1
@test "is-parent /Users/ $HOME" (is-parent /Users/ $HOME; and echo 1; or echo 0) = 1
@test "not is-parent /Users/ /" (is-parent /Users/ /; and echo 1; or echo 0) = 0
