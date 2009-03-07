require File.join( File.dirname(__FILE__), "spec_helper" )

describe DataMapper::YS::Config do
  before(:each) do
    @config = DataMapper::YS::Config.new
  end

  it "should provide []" do
    @config.should respond_to(:[])
  end

  describe "[:uniq]" do
    it "should has true as default value" do
      @config[:uniq].should == true
    end
  end

  it "should provide #uniq_page?" do
    @config.should respond_to(:uniq_page?)
  end

  describe "#uniq_page?" do
    it "should return true as default value" do
      @config.uniq_page?.should == true
    end

    it "should return true when :uniq is set to :page" do
      config = DataMapper::YS::Config.new(:uniq=>:page)
      config.uniq_page?.should == true
    end

    it "should return true when :uniq is set to :entry" do
      config = DataMapper::YS::Config.new(:uniq=>:entry)
      config.uniq_page?.should == true
    end

    it "should return false when :uniq is set to false" do
      config = DataMapper::YS::Config.new(:uniq=>false)
      config.uniq_page?.should == false
    end
  end

  it "should provide #uniq_entry?" do
    @config.should respond_to(:uniq_entry?)
  end

  describe "#uniq_entry?" do
    it "should return true as default value" do
      @config.uniq_entry?.should == true
    end

    it "should return false when :uniq is set to :page" do
      config = DataMapper::YS::Config.new(:uniq=>:page)
      config.uniq_entry?.should == false
    end

    it "should return true when :uniq is set to :entry" do
      config = DataMapper::YS::Config.new(:uniq=>:entry)
      config.uniq_entry?.should == true
    end

    it "should return false when :uniq is set to :page" do
      config = DataMapper::YS::Config.new(:uniq=>false)
      config.uniq_entry?.should == false
    end

  end
end
