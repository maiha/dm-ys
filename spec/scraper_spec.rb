require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YunkerStar::Proxy  do
  before(:each) do
    @scraper = Plugin.proxy
  end

  it "should provide #links" do
    @scraper.should respond_to(:links)
  end

  describe "#links" do
    it "should scrape a link tags"
  end

  it "should provide #label2name" do
    @scraper.respond_to?(:label2name, true).should == true
  end


end
