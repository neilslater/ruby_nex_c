# frozen_string_literal: true

require 'foo'

describe Foo do
  describe '#ruby_test' do
    it 'should return 42' do
      expect(Foo.ruby_test).to be 42
    end
  end
  describe '#ext_test' do
    it 'should return 8093' do
      expect(Foo.ext_test).to be 8093
    end
  end
end

describe Foo::Vector do
  describe 'class method' do
    describe '#new' do
      it 'should create a new valid Foo::Vector object' do
        expect(Foo::Vector.new(0, 0, 0)).to be_a Foo::Vector
      end

      it 'should reject non-numbers when instantiating' do
        expect { Foo::Vector.new('x', 0.0, 0.0) }.to raise_error TypeError
        expect { Foo::Vector.new(0, {}, 0.0) }.to raise_error TypeError
        expect { Foo::Vector.new(0, 0, []) }.to raise_error TypeError
      end
    end
  end

  describe 'instance method' do
    let(:fv) { Foo::Vector.new(1.0, 2.0, 3.0) }

    describe '#magnitude' do
      it 'should return length of a vector' do
        expect(fv.magnitude).to be_within(1e-9).of Math.sqrt(14.0)
      end
    end

    describe '#clone' do
      it 'should create a copy of a vector, including C-struct data' do
        fv_copy = fv.clone
        expect(fv_copy).to be_a Foo::Vector
        expect(fv_copy.object_id).to_not eql fv.object_id
        expect(fv_copy.magnitude).to be_within(1e-9).of Math.sqrt(14.0)
      end
    end
  end
end
