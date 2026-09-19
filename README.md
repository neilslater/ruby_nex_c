# Foo

[![CI](https://github.com/neilslater/ruby_nex_c/actions/workflows/ci.yml/badge.svg)](https://github.com/neilslater/ruby_nex_c/actions/workflows/ci.yml)

Example of gem that combines Ruby with a C native extension.

## Installation

Add this line to your application's Gemfile:

    gem 'foo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install foo

## Usage

This gem is a do-nothing skeleton, built starting from

    $ bundle gem foo

and then continued by adding support for native extensions in C.

Its purpose is to be a reference or starting point for other gems with both Ruby and C code.

`Foo::Vector.new(x, y, z).magnitude` returns the Euclidean length as a Float.
The C library uses `hypot` to avoid overflow or underflow from squaring
coordinates, so lengths such as `1e200` and `1e-200` remain representable.
Any NaN coordinate produces NaN, including when another coordinate is infinite.
Otherwise, infinite coordinates or a true length exceeding the double range
produce positive infinity.

Coordinates accept Integer, Float, Rational, and custom `to_f` conversions.
The private initializer converts in x, y, z order before writing native state;
conversion errors leave existing coordinates intact unless a callback itself
changes them. Frozen receivers reject initialization, including when a conversion
callback freezes the receiver.

`dup` and `clone` copy native coordinates independently while retaining Ruby's
normal shallow copying of instance variables, subclass identity, and singleton
method and freezing behavior. The private copy hook rejects frozen destinations
and different Ruby classes; self-copy remains a no-op even when frozen.

## Supported Ruby versions

This gem requires Ruby 3.3 or newer and supports maintained MRI release series,
as listed in Ruby's
[maintenance-branches schedule](https://www.ruby-lang.org/en/downloads/branches/).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
