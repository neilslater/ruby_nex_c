// ext/foo/foo_vector_ruby.h

////////////////////////////////////////////////////////////////////////////////////////////////
//
// This is the header for Ruby bindings that connect a "native" library to Ruby object-oriented
// framework.
//

#ifndef FOO_VECTOR_RUBY_H
#define FOO_VECTOR_RUBY_H

#include "foo_vector_lib.h"
#include <ruby.h>

// Ruby 1.8.7 compatibility patch
#ifndef DBL2NUM
#define DBL2NUM( dbl_val ) rb_float_new( dbl_val )
#endif

void init_foo_vector( VALUE parent_module );

#endif