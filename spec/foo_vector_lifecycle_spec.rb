# frozen_string_literal: true

require 'spec_helper'

describe Foo, :aggregate_failures do
  describe Foo::Vector do
    subject(:vector) { described_class.new(1, 2, 3) }

    let(:original_magnitude) { Math.sqrt(14) }
    let(:conversion_class) do
      Class.new do
        def initialize(&conversion)
          @conversion = conversion
        end

        def to_f
          @conversion.call
        end
      end
    end

    describe '#initialize' do
      let(:observations) { [] }
      let(:observing_coordinates) do
        [2.0, 3.0, 6.0].map do |value|
          conversion_class.new do
            observations << [value, vector.magnitude]
            value
          end
        end
      end
      let(:freezing_conversion) do
        conversion_class.new do
          vector.freeze
          40.0
        end
      end

      it 'keeps initialization private' do
        expect(vector.private_methods).to include(:initialize)
      end

      it 'accepts Integer, Float, and Rational coordinates' do
        expect(described_class.new(2, 3.0, Rational(6, 1)).magnitude).to eq(7.0)
      end

      it 'rejects a frozen receiver before invoking conversions' do
        conversion = conversion_class.new { raise 'conversion must not run' }
        vector.freeze

        expect { vector.send(:initialize, conversion, 0, 0) }.to raise_error(FrozenError)
        expect(vector.magnitude).to be_within(1e-15).of(original_magnitude)
      end

      [[10, {}, 0], [10, 20, []]].each do |coordinates|
        it "preserves existing coordinates when conversion fails for #{coordinates.inspect}" do
          expect { vector.send(:initialize, *coordinates) }.to raise_error(TypeError)
          expect(vector.magnitude).to be_within(1e-15).of(original_magnitude)
        end
      end

      [1, 2].each do |position|
        it "propagates callback exceptions at position #{position} without partial writes" do
          coordinates = [10, 20, 30]
          coordinates[position] = conversion_class.new { raise ArgumentError, 'conversion failed' }

          expect { vector.send(:initialize, *coordinates) }.to raise_error(ArgumentError, 'conversion failed')
          expect(vector.magnitude).to be_within(1e-15).of(original_magnitude)
        end
      end

      it 'converts in coordinate order with callbacks observing the old state' do
        previous = vector.magnitude
        vector.send(:initialize, *observing_coordinates)

        expect(observations).to eq([2.0, 3.0, 6.0].map { |value| [value, previous] })
        expect(vector.magnitude).to eq(7.0)
      end

      [0, 1, 2].each do |position|
        it "rejects a receiver frozen during conversion at position #{position}" do
          coordinates = [10, 20, 30]
          coordinates[position] = freezing_conversion

          expect { vector.send(:initialize, *coordinates) }.to raise_error(FrozenError)
          expect(vector.magnitude).to be_within(1e-15).of(original_magnitude)
        end
      end
    end

    describe '#initialize with reentrant conversion' do
      let(:mutating_conversion) do
        conversion_class.new do
          vector.send(:initialize, 3, 4, 0)
          10.0
        end
      end

      it 'does not roll back deliberate callback mutations when a later conversion fails' do
        expect { vector.send(:initialize, mutating_conversion, 20, []) }.to raise_error(TypeError)
        expect(vector.magnitude).to eq(5.0)
      end
    end

    describe '#initialize_copy' do
      it 'keeps the copy hook private' do
        expect(vector.private_methods).to include(:initialize_copy)
      end

      it 'rejects a frozen destination without changing its native state' do
        vector.freeze

        expect { vector.send(:initialize_copy, described_class.new(5, 0, 0)) }.to raise_error(FrozenError)
        expect(vector.magnitude).to be_within(1e-15).of(original_magnitude)
      end

      [false, true].each do |frozen|
        it "treats self-copy as a no-op with frozen=#{frozen}" do
          vector.freeze if frozen

          expect(vector.send(:initialize_copy, vector)).to equal(vector)
          expect(vector.magnitude).to be_within(1e-15).of(original_magnitude)
        end
      end

      it 'rejects an unrelated Ruby object' do
        expect { vector.send(:initialize_copy, Object.new) }.to raise_error(TypeError)
        expect(vector.magnitude).to be_within(1e-15).of(original_magnitude)
      end

      it 'rejects copying a subclass into the base class despite matching native layouts' do
        source = Class.new(described_class).new(5, 0, 0)

        expect { vector.send(:initialize_copy, source) }.to raise_error(TypeError)
        expect(vector.magnitude).to be_within(1e-15).of(original_magnitude)
      end

      it 'rejects copying the base class into a subclass' do
        destination = Class.new(described_class).new(5, 0, 0)

        expect { destination.send(:initialize_copy, vector) }.to raise_error(TypeError)
        expect(destination.magnitude).to eq(5.0)
      end

      it 'rejects copying between distinct subclasses' do
        source = Class.new(described_class).new(7, 0, 0)
        destination = Class.new(described_class).new(5, 0, 0)

        expect { destination.send(:initialize_copy, source) }.to raise_error(TypeError)
        expect(destination.magnitude).to eq(5.0)
      end
    end

    %i[dup clone].each do |method|
      describe "##{method}" do
        let(:copy) { vector.public_send(method) }
        let(:subclass) do
          Class.new(described_class) do
            attr_reader :metadata

            def initialize(init_x, init_y, init_z, metadata)
              super(init_x, init_y, init_z)
              @metadata = metadata
            end
          end
        end

        it 'copies native state independently in both directions' do
          expect { vector.send(:initialize, 3, 4, 0) }.not_to change(copy, :magnitude)

          copy.send(:initialize, 6, 8, 0)
          expect(vector.magnitude).to eq(5.0)
          expect(copy.magnitude).to eq(10.0)
        end

        it 'preserves subclass identity and shallow instance variables without calling the constructor' do
          original = subclass.new(3, 4, 0, [])
          subclass_copy = original.public_send(method)

          expect(subclass_copy).to be_instance_of(subclass)
          expect(subclass_copy.metadata).to equal(original.metadata)
          expect(subclass_copy.magnitude).to eq(5.0)
        end
      end
    end

    describe 'Ruby copy options' do
      it 'preserves freezing on default clone' do
        copy = vector.freeze.clone

        expect(copy).to be_frozen
        expect(copy.magnitude).to be_within(1e-15).of(original_magnitude)
      end

      it 'allows an independent unfrozen clone of a frozen vector' do
        copy = vector.freeze.clone(freeze: false)
        copy.send(:initialize, 3, 4, 0)

        expect(copy).not_to be_frozen
        expect(copy.magnitude).to eq(5.0)
        expect(vector.magnitude).to be_within(1e-15).of(original_magnitude)
      end

      it 'supports explicitly frozen clones' do
        copy = vector.clone(freeze: true)

        expect(copy).to be_frozen
        expect(copy.magnitude).to be_within(1e-15).of(original_magnitude)
      end

      it 'returns an unfrozen independent dup of a frozen vector' do
        copy = vector.freeze.dup
        copy.send(:initialize, 3, 4, 0)

        expect(copy).not_to be_frozen
        expect(vector.magnitude).to be_within(1e-15).of(original_magnitude)
      end

      it 'preserves singleton methods on clone' do
        vector.define_singleton_method(:label) { 'vector' }

        expect(vector.clone.label).to eq('vector')
      end

      it 'does not copy singleton methods on dup' do
        vector.define_singleton_method(:label) { 'vector' }

        expect(vector.dup).not_to respond_to(:label)
      end
    end
  end
end
