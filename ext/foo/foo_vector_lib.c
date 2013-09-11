// ext/foo/foo_vector_lib.c

////////////////////////////////////////////////////////////////////////////////////////////////
//
// This is the implementation of a small "C only" library, which has been made compatible with
// binding to Ruby. Note there are still some dependencies on ruby.h for xmalloc and xfree, which
// would need changing if the library was to be used elsewhere (probably easiest is to #define them
// and remove the #include <ruby.h>)
//
// It is not a full implementation of 3D vector class, it's just a stub of one to use
// as a template for any similar "C struct == Ruby class" projects.
//

#include "foo_vector_lib.h"
#include <ruby.h>

/*
 * Routines to create and destroy structs. If a struct contains
 * a pointer, it should be initialised to NULL, and further routines used to build
 * the deeper structures. Importantly, Ruby needs to be able to build a valid struct
 * when passing no parameters to the library.
 *
*/

FVStruct *create_fv_struct() {
  FVStruct *fv;
  fv = xmalloc( sizeof(FVStruct) );
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
