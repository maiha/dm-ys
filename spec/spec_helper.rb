require "rubygems"
require "spec"
require "pathname"

SPEC_ROOT = Pathname(__FILE__).dirname.expand_path
require SPEC_ROOT + "../lib/dm-ys"

def spec_data_path(name)
  SPEC_ROOT + "data/#{name}"
end

def spec_data(name)
  spec_data_path(name).read
end

Dir.glob(SPEC_ROOT + 'models' + '*.rb').each do |model|
  require model
end

######################################################################
### Mock for open-uri

begin
  require "open-uri-mapping"
rescue LoadError
  $stderr.puts "ERROR: need open-uri-mapping gem for test. Please install it by..."
  $stderr.puts "gem install maiha-open-uri-mapping --source=http://gems.github.com"
  exit
end

URI::Mapping.merge!(
  "http://merbi.st/plugins/index?page=1" => spec_data_path("plugins1.html"),
  "http://merbi.st/plugins/index?page=2" => spec_data_path("plugins2.html")
)

