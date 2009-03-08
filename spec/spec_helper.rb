require "rubygems"
require "spec"
require "pathname"

def spec_root
  Pathname(__FILE__).dirname.expand_path
end

def spec_data_path(name)
  spec_root + "data/#{name}"
end

def spec_data(name)
  spec_data_path(name).read
end

require spec_root + "../lib/dm-ys"

Dir.glob(spec_root + 'models' + '*.rb').each do |model|
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

mapping = {
  "http://merbi.st/plugins/" => spec_data_path("plugins1.html"),

  # plugin (paginated)
  "http://merbi.st/plugins/index?page=1" => spec_data_path("plugins1.html"),
  "http://merbi.st/plugins/index?page=2" => spec_data_path("plugins2.html"),

  # plugin + uniq
  "http://merbi.st/plugins/uniq?page=1" => spec_data_path("uniq1.html"),
  "http://merbi.st/plugins/uniq?page=2" => spec_data_path("uniq2.html"),

  # plugin + sorted
  "http://merbi.st/plugins/sorted?page=1"            => spec_data_path("sorted1.html"),
  "http://merbi.st/plugins/sorted?page=1&sort=name1" => spec_data_path("sorted1.html"),
  "http://merbi.st/plugins/sorted?page=1&sort=name2" => spec_data_path("sorted1.html"),
  "http://merbi.st/plugins/sorted?page=2"            => spec_data_path("sorted2.html"),
  "http://merbi.st/plugins/sorted?page=2&sort=name1" => spec_data_path("sorted2.html"),
  "http://merbi.st/plugins/sorted?page=2&sort=name2" => spec_data_path("sorted2.html"),
}
URI::Mapping.merge!(mapping)
