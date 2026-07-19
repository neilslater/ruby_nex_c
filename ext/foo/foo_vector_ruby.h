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

void init_foo_vector(VALUE parent_module);

#endif // FOO_VECTOR_RUBY_H
