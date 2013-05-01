// ext/foo/foo.c

#include <ruby.h>

// To hold the module object
VALUE Foo = Qnil;

// Declarations for bindings are here and not in header, as no need to share them with other C code.
void Init_foo();
VALUE method_ext_test(VALUE self);

// Setup the module and methods
void Init_foo() {
  Foo = rb_define_module("Foo");
  rb_define_singleton_method(Foo, "ext_test", method_ext_test, 0);
}

// Returns magic number 8093 as a test
VALUE method_ext_test(VALUE self) {
  return INT2NUM( 8093 );
}
