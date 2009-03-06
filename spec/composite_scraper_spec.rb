require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YunkerStar::Scraper::Composite do
  before(:each) do
    @scraper = DataMapper::YunkerStar::Scraper::Composite.new(Plugin)
  end

  it "should provide #uri" do
    @scraper.should respond_to(:uri)
  end

  describe "#uri" do
    it "should strip last '*'" do
      @scraper.uri.should == "http://merbi.st/plugins/index?page=1"
    end
  end

  it "should provide #pages" do
    @scraper.should respond_to(:pages)
  end

  describe "#pages" do
    it "should return page objects" do
      @scraper.pages.should be_kind_of(Array)
      @scraper.pages.map(&:uri).sort.should == 
        ["http://merbi.st/plugins/index?page=1","http://merbi.st/plugins/index?page=2"]
    end
  end

  it "should provide #count" do
    @scraper.should respond_to(:count)
  end

  describe "#count" do
    it "should return sum of page counts" do
      @scraper.count.should == 36
    end
  end

  it "should provide #names" do
    @scraper.should respond_to(:names)
  end

  describe "#names" do
    it "should return same value as Plugin" do
      @scraper.names.should == DataMapper::YunkerStar::Scraper::Page.new(Plugin1).names
    end
  end

  it "should provide #labels" do
    @scraper.should respond_to(:labels)
  end

  describe "#labels" do
    it "should return same value as Plugin" do
      @scraper.labels.should == DataMapper::YunkerStar::Scraper::Page.new(Plugin1).labels
    end
  end

  it "should provide #entries" do
    @scraper.should respond_to(:entries)
  end

  describe "#entries" do
    it "should return same value as Plugin" do
      @scraper.entries.should == (Plugin1.entries + Plugin2.entries)
    end
  end
end
