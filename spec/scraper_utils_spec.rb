require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YS::Scraper::Utils  do
  include DataMapper::YS::Scraper::Utils

  it "should provide .constantize" do
    DataMapper::YS::Scraper::Utils.should respond_to(:constantize)
  end

  describe ".constantize" do
    it "should strip spaces" do
      constantize(" a b ").should == 'ab'
    end

    it "should strip crlf and lf" do
      constantize("a\nb\r\n").should == 'ab'
    end

    it "should strip signs" do
      constantize("&<>").should == ''
    end

    it "should strip html references" do
      constantize("a&nbsp;b").should == 'ab'
    end

    it "should strip spaces and signs" do
      label = "EventMachine: fast, simple event-processing library for Ruby programs"
      expected = "EventMachinefastsimpleeventprocessinglibraryforRubyprograms"
      constantize(label).should == expected
    end

  end
end

