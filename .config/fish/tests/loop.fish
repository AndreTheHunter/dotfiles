test (_ 1) = '1'
test (loop _ 1) = '1'
test (loop _ [1]) = '1'
test (loop _ [1,2,3]) = '123'
test (loop _ {1,2,3}) = '123'
test (loop _ ['c a',t]) = 'c at'
