# frozen_string_literal: true

require 'objspace'
require 'spec_helper'

describe Foo do
  describe '#ruby_test' do
    it 'returns 42' do
      expect(described_class.ruby_test).to be 42
    end
  end

  describe '#ext_test' do
    it 'returns 8093' do
      expect(described_class.ext_test).to be 8093
    end
  end

  describe Foo::Vector do
    subject(:vector) { described_class.new(1.0, 2.0, 3.0) }

    describe '.new' do
      it 'creates a valid vector' do
        expect(described_class.new(0, 0, 0)).to be_a described_class
      end

      it 'rejects a non-number for x' do
        expect { described_class.new('x', 0.0, 0.0) }.to raise_error TypeError
      end

      it 'rejects a non-number for y' do
        expect { described_class.new(0, {}, 0.0) }.to raise_error TypeError
      end

      it 'rejects a non-number for z' do
        expect { described_class.new(0, 0, []) }.to raise_error TypeError
      end
    end

    describe '#magnitude' do
      it 'returns the length of a vector' do
        expect(vector.magnitude).to be_within(1e-9).of Math.sqrt(14.0)
      end
    end

    describe 'memory accounting' do
      it 'reports the memory used by its native struct' do
        # ObjectSpace invokes the typed-data dsize callback, covering the underlying C memory accounting.
        expect(ObjectSpace.memsize_of(vector)).to be_positive
      end
    end

    describe '#clone' do
      subject(:copy) { vector.clone }

      it 'creates another vector' do
        expect(copy).to be_a described_class
      end

      it 'creates a distinct object' do
        expect(copy.object_id).not_to eql vector.object_id
      end

      it 'copies the C-struct data' do
        expect(copy.magnitude).to be_within(1e-9).of Math.sqrt(14.0)
      end
    end
  end
end
