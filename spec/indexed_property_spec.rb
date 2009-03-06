require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YunkerStar do
  before(:each) do
    @plugin = Plugin1.first
  end

  it "should provide #[]" do
    @plugin.should respond_to(:[])
  end

  describe "#[]" do
    it "should accept symbol as a key" do
      @plugin[:id].should == 1
    end

    it "should accept string as a key" do
      @plugin["id"].should == 1
    end

    it "should accept integer as a key" do
      @plugin[0].should == 1
    end

    it "should raise InvalidIndex for unknown key" do
      lambda {
        @plugin[Object]
      }.should raise_error(DataMapper::YunkerStar::InvalidIndex)
    end
  end

end
