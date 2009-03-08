class Plugin
  include DataMapper::YS
  uri "http://merbi.st/plugins/index?page=1*"
end

class Plugin1
  include DataMapper::YS
  uri "http://merbi.st/plugins/index?page=1"
end

class Plugin2
  include DataMapper::YS
  uri "http://merbi.st/plugins/index?page=2"
end

class SortedPlugin
  include DataMapper::YS
  uri "http://merbi.st/plugins/sorted?page=1*"
  ys[:uniq] = false
end

class SortedPlugin1 < SortedPlugin
  uri "http://merbi.st/plugins/sorted?page=1"
end

class SortedPlugin2 < SortedPlugin
  uri "http://merbi.st/plugins/sorted?page=2"
end

class SortedPluginWithUniqPage
  include DataMapper::YS
  uri "http://merbi.st/plugins/sorted?page=1*"
  ys[:uniq] = :page
end

class UniqPlugin
  include DataMapper::YS
  uri "http://merbi.st/plugins/uniq?page=1*"
end

class UniqPlugin1
  include DataMapper::YS
  uri "http://merbi.st/plugins/uniq?page=1"
end

class UniqPlugin2
  include DataMapper::YS
  uri "http://merbi.st/plugins/uniq?page=2"
end
