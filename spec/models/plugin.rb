class Plugin
  include DataMapper::YunkerStar
  uri "http://merbi.st/plugins/index?page=1*"
end

class Plugin1
  include DataMapper::YunkerStar
  uri "http://merbi.st/plugins/index?page=1"
end

class Plugin2
  include DataMapper::YunkerStar
  uri "http://merbi.st/plugins/index?page=2"
end
