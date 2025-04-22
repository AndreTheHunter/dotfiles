setup() {
  load require-var
}

teardown() {
  unset TEST_VAR
}

@test "require-var does not error if variable is set" {
  require-var PATH
  export TEST_VAR=1
  require-var TEST_VAR
}

@test "require-var errors if variable is not set" {
  run require-var TEST_VAR
  [ $status -eq 1 ]
  [ "$output" = "Undeclared variable: TEST_VAR" ]
}

@test "require-var errors if multiple variable are not set" {
  run require-var TEST_VAR1 TEST_VAR2
  [ $status -eq 1 ]
  [ "$output" = "Undeclared variables: TEST_VAR1, TEST_VAR2" ]
}

@test "require-var works for local variables" {
  test_func() {
    local var1=$1
    local var2=$2
    require-var var1 var2
  }
  test_func 1 2
}

@test "require-var errors if local variable is not set" {
  test_func() {
    local var1=$1
    local var2=$2
    require-var var1 var2
  }
  test_func 1
}
