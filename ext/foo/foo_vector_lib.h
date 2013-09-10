// ext/foo/foo_vector_lib.h

// This is the header for a small "C only" library, which has been made compatible with
// binding to Ruby, but has no interaction with Ruby, and does not use functions from ruby.h

#ifndef FOO_VECTOR_LIB_H
#define FOO_VECTOR_LIB_H

#include <stdlib.h>
#include <string.h>

// For sqrt
#include <math.h>

// This is the struct that the rest of the code wraps
typedef struct _fv {
    double x;
    double y;
    double z;
  } FVStruct;

FVStruct *create_fv_struct();
void destroy_fv_struct( FVStruct *fv );
FVStruct *copy_fv_struct( FVStruct *orig );
double fv_magnitude( FVStruct *fv );

#endif