require 'foo'

describe Foo do
  describe "#ext_test" do
    it "should return 8093" do
      Foo.ext_test.should == 8093
    end
  end
end
