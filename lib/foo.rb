# frozen_string_literal: true

require 'foo/version'
require 'foo/foo'

# Example API backed by both Ruby and a native C extension.
module Foo
  # Returns a test value from Ruby.
  #
  # @return [Integer] the value 42
  def self.ruby_test
    42
  end

  # @!method self.ext_test
  #   Returns a test value from the native extension.
  #   @return [Integer] the value 8093

  # A three-dimensional vector whose data and operations are implemented in C.
  #
  # @!method initialize(x, y, z)
  #   Creates a vector.
  #   @param x [Numeric] x coordinate
  #   @param y [Numeric] y coordinate
  #   @param z [Numeric] z coordinate
  #   @raise [TypeError] if any coordinate cannot be converted to a number
  #
  # @!method magnitude
  #   Calculates the vector's Euclidean length.
  #   @return [Float] the vector magnitude
  class Vector # rubocop:disable Lint/EmptyClass
  end
end
