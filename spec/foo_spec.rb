require 'foo'

describe Foo do
  describe "#ruby_test" do
    it "should return 42" do
      Foo.ruby_test.should == 42
    end
  end
  describe "#ext_test" do
    it "should return 8093" do
      Foo.ext_test.should == 8093
    end
  end
end

describe Foo::Vector do
  describe "class method" do
    describe "#new" do
      it "should create a new valid Foo::Vector object" do
        Foo::Vector.new( 0, 0, 0 ).should be_a Foo::Vector
      end

      it "should reject non-numbers when instantiating" do
        lambda { Foo::Vector.new( 'x', 0.0, 0.0 ) }.should raise_error TypeError
        lambda { Foo::Vector.new( 0, {}, 0.0 ) }.should raise_error TypeError
        lambda { Foo::Vector.new( 0, 0, [] ) }.should raise_error TypeError
      end
    end
  end

  describe "instance method" do
    let(:fv) { Foo::Vector.new( 1.0, 2.0, 3.0 ) }

    describe "#magnitude" do
      it "should return length of a vector" do
        fv.magnitude.should be_within(1e-9).of Math.sqrt( 14.0 )
      end
    end

    describe "#clone" do
      it "should create a copy of a vector, including C-struct data" do
        fv_copy = fv.clone
        fv_copy.should be_a Foo::Vector
        fv_copy.object_id.should_not == fv.object_id
        fv_copy.magnitude.should be_within(1e-9).of Math.sqrt( 14.0 )
      end
    end
  end
end