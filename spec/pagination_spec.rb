require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YunkerStar do
  it "should provide proxy" do
    Plugin.count.should == 20
  end
end
