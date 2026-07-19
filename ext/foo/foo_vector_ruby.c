// ext/foo/foo_vector_ruby.c

////////////////////////////////////////////////////////////////////////////////////////////////
//
// This is the implementation of Ruby bindings that connect a "native" library based on a C
// struct to the Ruby API
//

#include "foo_vector_ruby.h"

/*
 * Generic Ruby integration - helper functions working with FVStruct pointers
 *
*/

// Reports the memory used by the wrapped C struct.
static size_t foo_vector_memsize(const void *ptr) {
  return ptr == NULL ? 0 : sizeof(FVStruct);
}

// Describes the wrapped C struct to Ruby's garbage collector.
static const rb_data_type_t foo_vector_type = {
  .wrap_struct_name = "Foo::Vector",
  .function = {
    .dmark = NULL,
    .dfree = RUBY_DEFAULT_FREE,
    .dsize = foo_vector_memsize,
  },
  .flags = RUBY_TYPED_FREE_IMMEDIATELY,
};

// This method *must* take no params, and return a ready-to-use
// Ruby object, with memory already allocated if any needed.
static VALUE foo_vector_alloc(VALUE klass) {
  FVStruct *fv;

  return TypedData_Make_Struct(klass, FVStruct, &foo_vector_type, fv);
}

static FVStruct *get_fv_struct(VALUE obj) {
  FVStruct *fv;

  TypedData_Get_Struct(obj, FVStruct, &foo_vector_type, fv);
  return fv;
}

/*
 * Functions that can be bound to a Ruby class
 *
*/

// Native extensions version of initialize
static VALUE foo_vector_initialize(VALUE self, VALUE init_x, VALUE init_y, VALUE init_z) {
  FVStruct *fv = get_fv_struct(self);

  fv->x = NUM2DBL(init_x);
  fv->y = NUM2DBL(init_y);
  fv->z = NUM2DBL(init_z);

  return self;
}

// Special initialize to support "clone"
static VALUE foo_vector_initialize_copy(VALUE copy, VALUE orig) {
  FVStruct *fv_copy;
  FVStruct *fv_orig;

  if (copy == orig) {
    return copy;
  }

  fv_copy = get_fv_struct(copy);
  fv_orig = get_fv_struct(orig);
  *fv_copy = *fv_orig;

  return copy;
}

// Example of using a "native" struct method
static VALUE foo_vector_magnitude(VALUE self) {
  const FVStruct *fv = get_fv_struct(self);

  return DBL2NUM(fv_magnitude(fv));
}

/*
 * Create bindings, should be called as part of library initialisation
 *
*/

void init_foo_vector(VALUE parent_module) {
  VALUE foo_vector = rb_define_class_under(parent_module, "Vector", rb_cObject);

  rb_define_alloc_func(foo_vector, foo_vector_alloc);
  rb_define_method(foo_vector, "initialize", foo_vector_initialize, 3);
  rb_define_method(foo_vector, "initialize_copy", foo_vector_initialize_copy, 1);
  rb_define_method(foo_vector, "magnitude", foo_vector_magnitude, 0);
}
