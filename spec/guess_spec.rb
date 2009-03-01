require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YunkerStar do
  class ::BlankHtml
    include DataMapper::YunkerStar
    uri spec_data_path("blank.html")
  end

  class ::BlankStyle
    include DataMapper::YunkerStar
    uri spec_data_path("ki.html")
  end

  class ::TableStyle < BlankStyle
    uri spec_data_path("ki.html")
    table "table.main"
  end

  class ::TheadStyle < BlankStyle
    uri spec_data_path("ki.html")
    thead "table.main"
  end

  it "should provide proxy" do
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
        BlankStyle.proxy.guess_table["class"].should == "main"
      end

      it "should raise when the html contains no tables" do
        lambda {
          BlankHtml.proxy.guess_table
        }.should raise_error(DataMapper::YunkerStar::Scraper::TableNotFound)
      end
    end

    it "should provide table" do
      BlankStyle.proxy.should respond_to(:table)

      describe "#table" do
        it "should raise when the html contains no tables" do
          lambda {
            BlankHtml.proxy.table
          }.should raise_error(DataMapper::YunkerStar::Scraper::TableNotFound)
        end

        it "should return specified table" do
          table = TableStyle.proxy.table
          table.class.should == Hpricot::Elem
          table[:class].should == "main"
        end
      end
    end

    it "should provide thead" do
      BlankStyle.proxy.should respond_to(:thead)

      describe "#thead" do
        it "should raise when the html contains no tables" do
          lambda {
            BlankHtml.proxy.thead
          }.should raise_error(DataMapper::YunkerStar::Scraper::TableNotFound)
        end
      end
    end

    it "should provide labels" do
      BlankStyle.proxy.should respond_to(:labels)

      describe "#labels" do
        it "should return th values" do
          BlankStyle.proxy.labels.map(&:strip).should == %w( col1 col2 col3 col4 )
        end
      end
    end

  end
end
