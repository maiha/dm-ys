require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YS do
  ######################################################################
  ### Config

  it "should provide .ys" do
    Plugin.should respond_to(:ys)
  end

  describe ".ys" do
    it "should return a ys config" do
      Plugin.ys.should be_kind_of(DataMapper::YS::Config)
    end

    describe "[:max_pages]" do
      class NetworkUnreachable
        include DataMapper::YS
        uri "http://merbi.st/plugins/index?page=1*"
        ys[:max_pages] = 0
      end

      it "should has 100 as default value" do
        Plugin.ys[:max_pages].should == 100
      end

      it "should raise MaxPagesOverflow when count of visited sites exceeds :max_pages value" do
        lambda {
          NetworkUnreachable.count
        }.should raise_error(DataMapper::YS::Proxy::MaxPagesOverflow)
      end
    end
  end

  ######################################################################
  ### Proxy

  it "should provide .proxy" do
    BlankStyle.should respond_to(:proxy)
  end

  describe ".proxy" do
    it "should provide guess_table" do
      BlankStyle.proxy.should respond_to(:guess_table)
    end

    describe "#guess_table" do
      it "should return a Hpricot::Elem" do
        BlankStyle.proxy.guess_table.class.should == Hpricot::Elem
      end

      it "should return a right element" do
        BlankStyle.proxy.guess_table[:class].should == "plugin-list"
      end

      it "should raise when the html contains no tables" do
        lambda {
          BlankHtml.proxy.guess_table
        }.should raise_error(DataMapper::YS::Scraper::TableNotFound)
      end
    end

    it "should provide table" do
      BlankStyle.proxy.should respond_to(:table)

      describe "#table" do
        it "should raise when the html contains no tables" do
          lambda {
            BlankHtml.proxy.table
          }.should raise_error(DataMapper::YS::Scraper::TableNotFound)
        end

        it "should return specified table" do
          table = TableStyle.proxy.table
          table.class.should == Hpricot::Elem
          table[:class].should == "plugin-list"
        end
      end
    end

    it "should provide thead" do
      BlankStyle.proxy.should respond_to(:thead)
    end

    describe "#thead" do
      it "should raise when the html contains no tables" do
        lambda {
          BlankHtml.proxy.thead
        }.should raise_error(DataMapper::YS::Scraper::TableNotFound)
      end
    end

    it "should provide labels" do
      BlankStyle.proxy.should respond_to(:labels)
    end

    describe "#labels" do
      it "should return th values" do
        BlankStyle.proxy.labels.map(&:strip).should ==
          ["Name", "Repos", "Registered by", "Description", ""]
      end
    end
  end
end
