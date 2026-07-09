@test "trim ' a '" (trim ' a ') = 'a'
@test "trim 'a '" (trim 'a ') = 'a'
@test "trim ' a'" (trim ' a') = 'a'
@test "trim from stdin" (echo ' a '|trim) = 'a'