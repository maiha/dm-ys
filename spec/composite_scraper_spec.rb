require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YS::Scraper::Composite do
  before(:each) do
    @scraper = DataMapper::YS::Scraper::Composite.new(Plugin)
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
      @scraper.names.should == DataMapper::YS::Scraper::Page.new(Plugin1).names
    end
  end

  it "should provide #labels" do
    @scraper.should respond_to(:labels)
  end

  describe "#labels" do
    it "should return same value as Plugin" do
      @scraper.labels.should == DataMapper::YS::Scraper::Page.new(Plugin1).labels
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

  describe "SortedPlugin" do
    it "should return 6 pages" do
      SortedPlugin.proxy.pages.size.should == 6
    end

    describe "#entries" do
      it "should return duplicate entries" do
        SortedPlugin.entries.sort.should == ((SortedPlugin1.entries + SortedPlugin2.entries)*3).sort
      end
    end

    describe "#count" do
      it "should return duplicate entries" do
        SortedPlugin.count.should == (SortedPlugin1.count + SortedPlugin2.count)*3
      end
    end
  end

  describe "SortedPlugin with uniq page option" do
    it "should return 2 pages" do
      SortedPluginWithUniqPage.proxy.pages.size.should == 2
    end

    describe "#entries" do
      it "should return same value as Plugin" do
        SortedPluginWithUniqPage.entries.should == (SortedPlugin1.entries + SortedPlugin2.entries)
      end
    end

    describe "#count" do
      it "should return same value as Plugin" do
        SortedPluginWithUniqPage.count.should == (SortedPlugin1.count + SortedPlugin2.count)
      end
    end
  end

  describe "UniqPlugin" do
    it "should return 2 pages" do
      UniqPlugin.proxy.pages.size.should == 2
    end

    describe "#count" do
      it "should return same value as Plugin" do
        UniqPlugin1.count.should == 20
        UniqPlugin2.count.should == 4
        UniqPlugin .count.should == 22
      end
    end
  end


end
