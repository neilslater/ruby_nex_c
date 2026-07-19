// ext/foo/foo_vector_lib.c

////////////////////////////////////////////////////////////////////////////////////////////////
//
// This is a small C-only vector library used by the Ruby bindings.
//
// It is not a full implementation of 3D vector class, it's just a stub of one to use
// as a template for any similar "C struct == Ruby class" projects.
//

#include "foo_vector_lib.h"

/*
 * C functions that work with vector struct pointers
 *
*/

double fv_magnitude(const FVStruct *fv) {
  return sqrt(fv->x * fv->x + fv->y * fv->y + fv->z * fv->z);
}
