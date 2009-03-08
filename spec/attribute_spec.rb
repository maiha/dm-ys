require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YS, "(a record)" do
  before(:each) do
    @record = Plugin.first
  end

  it "should provide #link_for" do
    @record.should respond_to(:link_for)
  end
end
