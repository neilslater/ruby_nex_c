# Changelog

## Unreleased

- Require Ruby 3.3 or newer.
- Avoid intermediate overflow and underflow in vector magnitudes while preserving
  NaN propagation, including mixed NaN/infinity inputs.
- Respect frozen receivers and same-class checks in native vector initialization
  and copying, preserving self-copy as a no-op.
- Convert all coordinates before writing native state, preventing partial writes
  on conversion errors and rejecting receivers frozen by conversion callbacks.

## 0.0.1

- Initial release.
