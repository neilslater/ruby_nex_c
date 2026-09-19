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

  # @!parse
  #   # A three-dimensional vector whose data and operations are implemented in C.
  #   class Vector
  #     # Creates a vector, converting coordinates to doubles in x, y, z order.
  #     # Accepts Integer, Float, Rational, and objects whose to_f returns a Float.
  #     # Conversion can run Ruby code or raise; native coordinates are written only
  #     # after all conversions succeed and the receiver is checked again for freezing.
  #     # This does not undo side effects performed by conversion callbacks themselves.
  #     # @param x [Numeric] x coordinate
  #     # @param y [Numeric] y coordinate
  #     # @param z [Numeric] z coordinate
  #     # @raise [TypeError] if any coordinate cannot be converted to a number
  #     # @raise [FrozenError] if the receiver is frozen before or during conversion
  #     def initialize(x, y, z); end
  #
  #     # Calculates the vector's Euclidean length.
  #     # Avoids intermediate overflow and underflow for representable lengths.
  #     # Any NaN coordinate produces NaN, even alongside infinity. Otherwise,
  #     # infinite coordinates or a length beyond the double range produce infinity.
  #     # @return [Float] the vector magnitude
  #     def magnitude; end
  #   end
end
