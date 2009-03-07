require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YS do
  it "should provide proxy" do
    Plugin1.count.should == 20
  end
end
