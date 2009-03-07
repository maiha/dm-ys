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

class SortedPlugin
  include DataMapper::YunkerStar
  uri "http://merbi.st/plugins/sorted?page=1*"
  ys[:uniq] = false
end

class SortedPlugin1
  include DataMapper::YunkerStar
  uri "http://merbi.st/plugins/sorted?page=1"
  ys[:uniq] = false
end

class SortedPlugin2
  include DataMapper::YunkerStar
  uri "http://merbi.st/plugins/sorted?page=2"
  ys[:uniq] = false
end

class SortedPluginWithUniqPage
  include DataMapper::YunkerStar
  uri "http://merbi.st/plugins/sorted?page=1*"
  ys[:uniq] = :page
end

class UniqPlugin
  include DataMapper::YunkerStar
  uri "http://merbi.st/plugins/uniq?page=1*"
end

class UniqPlugin1
  include DataMapper::YunkerStar
  uri "http://merbi.st/plugins/uniq?page=1"
end

class UniqPlugin2
  include DataMapper::YunkerStar
  uri "http://merbi.st/plugins/uniq?page=2"
end
