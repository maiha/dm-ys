require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YS::Scraper::Composite do
  describe "UniqPlugin" do
    it "should return 2 pages" do
      UniqPlugin.proxy.pages.size.should == 2
    end

    describe "#count" do
      it "should return same value as Plugin" do
        UniqPlugin1.count.should == 2
        UniqPlugin2.count.should == 2
        UniqPlugin .count.should == 3
      end
    end
  end
end
