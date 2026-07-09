@test "add-suffix '/' 'a'" (add-suffix '/' 'a') = a/
@test "add-suffix '/' '/'" (add-suffix '/' '/') = /
@test "add-suffix '//' '/'" (add-suffix '//' '/') = ///
