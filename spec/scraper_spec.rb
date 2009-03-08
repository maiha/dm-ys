require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YS::Proxy  do
  before(:each) do
    @scraper = DataMapper::YS::Scraper::Page.new(Plugin1)
  end

  it "should provide #uri" do
    @scraper.should respond_to(:uri)
  end

  describe "#uri" do
    it "should return uri" do
      @scraper.uri.should == "http://merbi.st/plugins/index?page=1"
    end
  end

  it "should provide #pagination_links" do
    @scraper.should respond_to(:pagination_links)
  end

  describe "#pagination_links" do
    it "should scrape pagination links" do
      @scraper.pagination_links.should == ["http://merbi.st/plugins/index?page=2"]
    end
  end

  it "should provide #label2name" do
    @scraper.respond_to?(:label2name, true).should == true
  end

  it "should provide #page_hash" do
    @scraper.should respond_to(:page_hash)
  end

  describe "#page_hash" do
    it "should return a string" do
      @scraper.page_hash.should be_kind_of(String)
    end
  end

  ######################################################################
  ### Guess tbody

  it "should ignore th columns" do
    ThStyle.count.should == 2
  end
end
