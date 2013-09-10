// ext/foo/foo.c

#include <ruby.h>
#include "foo_vector_ruby.h"

// To hold the module object
VALUE Foo = Qnil;

// Returns magic number 8093 as a test
VALUE method_ext_test(VALUE self) {
  return INT2NUM( 8093 );
}

// Setup the module, a module method, and an extension class
void Init_foo() {
  Foo = rb_define_module("Foo");
  rb_define_singleton_method(Foo, "ext_test", method_ext_test, 0);
  init_foo_vector( Foo );
}
