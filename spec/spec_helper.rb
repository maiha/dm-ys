require "rubygems"
require "spec"

require File.dirname(__FILE__) + "/../lib/dm-ys"

def spec_data_path(name)
  Pathname(File.dirname(__FILE__) + "/data/#{name}")
end

def spec_data(name)
  spec_data_path(name).read
end
