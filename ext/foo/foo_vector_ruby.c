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

// A reference to the class object
VALUE FooVector = Qnil;

inline VALUE fv_as_ruby_class( FVStruct *fv , VALUE klass ) {
  return Data_Wrap_Struct( klass, 0, destroy_fv_struct, fv );
}

// This method *must* take no params, and return a ready-to-use
// Ruby object, with memory already allocated if any needed.
VALUE fv_alloc(VALUE klass) {
  return fv_as_ruby_class( create_fv_struct(), klass );
}

inline FVStruct *get_fv_struct( VALUE obj ) {
  FVStruct *fv;
  Data_Get_Struct( obj, FVStruct, fv );
  return fv;
}

void assert_value_wraps_fv( VALUE obj ) {
  if ( TYPE(obj) != T_DATA ||
      RDATA(obj)->dfree != (RUBY_DATA_FUNC)destroy_fv_struct) {
    rb_raise( rb_eTypeError, "Expected a Foo::Vector object, but got something else" );
  }
}

/*
 * Functions that can be bound to a Ruby class
 *
*/

// Native extensions version of initialize
VALUE foo_vector_initialize( VALUE self, VALUE init_x, VALUE init_y, VALUE init_z ) {
  FVStruct *fv = get_fv_struct( self );

  fv->x = NUM2DBL( init_x );
  fv->y = NUM2DBL( init_y );
  fv->z = NUM2DBL( init_z );

  return self;
}

// Special initialize to support "clone"
VALUE foo_vector_initialize_copy( VALUE copy, VALUE orig ) {
  FVStruct *fv_copy;
  FVStruct *fv_orig;

  if (copy == orig) return copy;
  fv_copy = get_fv_struct( copy );
  fv_orig = get_fv_struct( orig );
  memcpy( fv_copy, fv_orig, sizeof(FVStruct) );

  return copy;
}

// Example of using a "native" struct method
VALUE foo_vector_magnitude( VALUE self ) {
  FVStruct *fv = get_fv_struct( self );
  return DBL2NUM( fv_magnitude( fv ) );
}

/*
 * Create bindings, should be called as part of library initialisation
 *
*/

void init_foo_vector( VALUE parent_module ) {
  FooVector = rb_define_class_under( parent_module, "Vector", rb_cObject );
  rb_define_alloc_func( FooVector, fv_alloc );
  rb_define_method( FooVector, "initialize", foo_vector_initialize, 3 );
  rb_define_method( FooVector, "initialize_copy", foo_vector_initialize_copy, 1 );
  rb_define_method( FooVector, "magnitude", foo_vector_magnitude, 0 );
}
