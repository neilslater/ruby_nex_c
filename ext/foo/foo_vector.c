// ext/foo/foo_vector.c

// An example of using a C struct as a Ruby object.
// This is not a full implementation of 3D vector class, it's just the bare outline of one to use
// as a template for any similar "C struct == Ruby class" projects.

#include "foo_vector.h"

/*
 * Routines to create and destroy structs. If a struct contains
 * a pointer, it should be initialised to NULL, and further routines used to build
 * the deeper structures. Importantly, Ruby needs to be able to build a valid struct
 * when passing no parameters to the library.
 *
*/

FVStruct *create_fv_struct() {
  FVStruct *fv;
  fv = malloc (sizeof(FVStruct));
  if ( fv == NULL ) {
    rb_raise( rb_eRuntimeError, "Could not allocate memory for Foo::Vector" );
  }
  fv->x = 0.0;
  fv->y = 0.0;
  fv->z = 0.0;
  return fv;
}

void destroy_fv_struct( FVStruct *fv ) {
  xfree( fv );
  return;
}

// Note this isn't called from initialize_copy, it's for internal copies
FVStruct *copy_fv_struct( FVStruct *orig ) {
  FVStruct *fv = create_fv_struct();
  memcpy( fv, orig, sizeof(FVStruct) );
  return fv;
}

/*
 * "Native" routines that work with struct pointers
 *
*/

double fv_magnitude( FVStruct *fv ) {
  return sqrt( fv->x * fv->x + fv->y * fv->y + fv->z * fv->z );
}

/*
 * Generic Ruby integration
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
 * C implementations of methods for binding with Ruby
 *
*/

// C version of initialize
VALUE foo_vector_initialize( VALUE self, VALUE init_x, VALUE init_y, VALUE init_z ) {
  FVStruct *fv = get_fv_struct( self );

  fv->x = NUM2DBL( init_x );
  fv->y = NUM2DBL( init_y );
  fv->z = NUM2DBL( init_z );

  return self;
}

// Special initialize on copy
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
 * Defined bindings, needs to be called when class is loaded
 *
*/

void init_foo_vector( VALUE parent_module ) {
  FooVector = rb_define_class_under( parent_module, "Vector", rb_cObject );
  rb_define_alloc_func( FooVector, fv_alloc );
  rb_define_method( FooVector, "initialize", foo_vector_initialize, 3 );
  rb_define_method( FooVector, "initialize_copy", foo_vector_initialize_copy, 1 );
  rb_define_method( FooVector, "magnitude", foo_vector_magnitude, 0 );
}
