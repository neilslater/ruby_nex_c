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
