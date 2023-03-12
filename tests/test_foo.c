#include <criterion/criterion.h>

#include "ctemplate/foo.h"

Test(test_foo, foo) { cr_expect(ctemplate_foo(10, 10) == 20); }
