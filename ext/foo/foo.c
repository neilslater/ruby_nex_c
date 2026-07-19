// ext/foo/foo.c

////////////////////////////////////////////////////////////////////////////////////////////////
//
// This is the extension entry point. Ruby calls Init_foo() when requiring the compiled library.
//

#include <ruby.h>
#include "foo_vector_ruby.h"

// Returns magic number 8093 as a test
static VALUE method_ext_test(VALUE self) {
  (void)self;
  return INT2NUM(8093);
}

RUBY_FUNC_EXPORTED void Init_foo(void) {
  VALUE foo_module = rb_define_module("Foo");

  rb_define_singleton_method(foo_module, "ext_test", method_ext_test, 0);
  init_foo_vector(foo_module);
}
