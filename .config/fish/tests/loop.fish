@test "loop dummy 1" (loop echo 1) = '1'
@test "loop dummy {1,2,3}" (loop printf '%s' {1,2,3}) = '123'
