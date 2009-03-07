require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YS, "(a record)" do
  before(:each) do
    @record = Plugin.first
  end

  it "should provide #link_for" do
    @record.should respond_to(:link_for)
  end

  describe "#link_for" do
    it "should return first link if its element has href attributes" do
      @record.link_for(:name).should == "/plugins/36"
    end

    it "should return nil if its element has no href attributes"
  end

  it "should provide #element_for" do
    @record.should respond_to(:element_for)
  end

end
