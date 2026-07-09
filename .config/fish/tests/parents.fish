@test "parents /a/b/c" (parents /a/b/c | string join ' ') = "/a/b /a /"
@test "parents /" (parents / | string join ' ') = "/"
@test "parents /a" (parents /a | string join ' ') = "/"
@test "parents with no args (PWD)" (parents | string join ' ') = (parents $PWD | string join ' ')
mkdir -p "/tmp/a b/c"
@test "parents with spaces" (parents "/tmp/a b/c" | string join ' ') = "/tmp/a b /tmp /"
rm -rf "/tmp/a b"
