// ext/foo/foo_vector_lib.c

////////////////////////////////////////////////////////////////////////////////////////////////
//
// This is the implementation of a small "C only" library, which has been made compatible with
// binding to Ruby, but has no interaction with Ruby, and does not use functions from ruby.h
//
// It is not a full implementation of 3D vector class, it's just a stub of one to use
// as a template for any similar "C struct == Ruby class" projects.
//

#include "foo_vector_lib.h"

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
  if ( fv != NULL ) {
    fv->x = 0.0;
    fv->y = 0.0;
    fv->z = 0.0;
  }
  // What to do if this is NULL?
  return fv;
}

void destroy_fv_struct( FVStruct *fv ) {
  if ( fv == NULL ) {
    return;
  }
  // Should we use "xfree" here? It isn't clear how to do this without ruby.h
  free( fv );
  return;
}

// Note this isn't called from initialize_copy, it's for internal copies
FVStruct *copy_fv_struct( FVStruct *orig ) {
  FVStruct *fv = create_fv_struct();
  if ( fv != NULL ) {
    memcpy( fv, orig, sizeof(FVStruct) );
  }
  // What to do if this is NULL?
  return fv;
}

/*
 * "Native" routines that work with struct pointers
 *
*/

double fv_magnitude( FVStruct *fv ) {
  return sqrt( fv->x * fv->x + fv->y * fv->y + fv->z * fv->z );
}
