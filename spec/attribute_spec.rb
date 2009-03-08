require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YS, "(a record)" do
  class OnlyPath
    include DataMapper::YS
    uri "http://merbi.st/plugins/"
    ys[:only_path] = true
  end

  before(:each) do
    @record = Plugin.first
  end

  it "should provide #link_for" do
    @record.should respond_to(:link_for)
  end

  describe "#link_for" do
    it "should return first link if its element has href attributes" do
      @record.link_for("Name").should == "http://merbi.st/plugins/36"
    end

    it "should return nil if its element has no href attributes" do
      @record.link_for("Description").should == nil
    end

    it "should return only path link when :only_path is true" do
      OnlyPath.first.link_for("Name").should == "/plugins/36"
    end
  end

  it "should provide #element_for" do
    @record.should respond_to(:element_for)
  end

  describe "#element_for" do
    it "should return first link if its element has href attributes" do
      @record.element_for("Name").to_s.should == "<td><a href=\"/plugins/36\">eventmachine-0.12.5</a></td>"
    end
  end

end
