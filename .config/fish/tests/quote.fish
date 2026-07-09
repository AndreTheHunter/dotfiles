@test "quote a" (quote a) = "'a'"
@test "quote a b" (quote a b) = "'a' 'b'"
@test "quote \"'\"" (quote "'") = "'\''"
