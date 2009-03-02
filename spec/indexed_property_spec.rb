require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YunkerStar do
  class ::Cute1
    include DataMapper::YunkerStar
    uri spec_data_path("cute1.html")
  end

  before(:each) do
    @cute = Cute1.first
  end

  it "should provide #[]" do
    @cute.should respond_to(:[])
  end

  describe "#[]" do
    it "should accept symbol as a key" do
      @cute[:id].should == 1
    end

    it "should accept string as a key" do
      @cute["id"].should == 1
    end

    it "should accept integer as a key" do
      @cute[0].should == 1
    end

    it "should raise InvalidIndex for unknown key" do
      lambda {
        @cute[Object]
      }.should raise_error(DataMapper::YunkerStar::InvalidIndex)
    end
  end

end
