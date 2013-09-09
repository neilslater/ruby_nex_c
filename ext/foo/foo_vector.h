// ext/foo/foo_vector.h


// Declarations for wrapped struct

#ifndef FOO_VECTOR_H
#define FOO_VECTOR_H

#include <ruby.h>
#include <math.h>

// Ruby 1.8.7 compatibility patch
#ifndef DBL2NUM
#define DBL2NUM( dbl_val ) rb_float_new( dbl_val )
#endif

void init_foo_vector( VALUE parent_module );

// This is the struct that the rest of the code wraps
typedef struct _fv {
    double x;
    double y;
    double z;
  } FVStruct;

#endif