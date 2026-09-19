# frozen_string_literal: true

require 'spec_helper'

describe Foo, :aggregate_failures do
  describe Foo::Vector, '#magnitude' do
    [
      [[1e200, 0, 0], 1e200],
      [[0, 1e-200, 0], 1e-200],
      [[0, 0, -1e200], 1e200],
      [[3e200, -4e200, 0], 5e200],
      [[-3e-200, 0, 4e-200], 5e-200],
      [[1e200, 1e-200, -1], 1e200],
      [[3, 4, 0], 5],
      [[-3, -4, 0], 5]
    ].each do |coordinates, expected|
      it "returns the representable length for #{coordinates.inspect}" do
        magnitude = described_class.new(*coordinates).magnitude

        expect(magnitude).to be_a Float
        expect(magnitude).to be_finite
        expect(magnitude).to be_positive
        expect(magnitude / expected).to be_within(1e-15).of(1)
      end
    end

    it 'returns zero for zero coordinates' do
      expect(described_class.new(0, -0.0, 0).magnitude).to eq(0.0)
    end

    it 'returns positive infinity when the true length exceeds the double range' do
      expect(described_class.new(Float::MAX, Float::MAX, Float::MAX).magnitude).to eq(Float::INFINITY)
    end

    [Float::INFINITY, -Float::INFINITY].each do |infinity|
      [infinity, 0, 1].permutation.each do |coordinates|
        it "returns positive infinity for #{coordinates.inspect}" do
          expect(described_class.new(*coordinates).magnitude).to eq(Float::INFINITY)
        end
      end
    end

    [0, Float::INFINITY, -Float::INFINITY].each do |other|
      [Float::NAN, other, 1].permutation.each do |coordinates|
        it "propagates NaN for #{coordinates.inspect}" do
          expect(described_class.new(*coordinates).magnitude).to be_nan
        end
      end
    end
  end
end
