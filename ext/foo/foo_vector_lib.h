// ext/foo/foo_vector_lib.h

////////////////////////////////////////////////////////////////////////////////////////////////
//
// This is the header for a small "C only" library, which has been made compatible with
// binding to Ruby, but has no interaction with Ruby, and does not use functions from ruby.h
//

#ifndef FOO_VECTOR_LIB_H
#define FOO_VECTOR_LIB_H

#include <math.h>

// This is the struct that the rest of the code wraps
typedef struct {
  double x;
  double y;
  double z;
} FVStruct;

double fv_magnitude(const FVStruct *fv);

#endif // FOO_VECTOR_LIB_H
