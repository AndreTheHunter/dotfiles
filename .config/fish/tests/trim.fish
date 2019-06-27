test (trim ' a ') = 'a'
test (trim 'a ') = 'a'
test (trim ' a') = 'a'
test (echo ' a '|trim) = 'a'