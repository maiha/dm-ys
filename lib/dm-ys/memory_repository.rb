module DataMapper
  module YunkerStar
    ######################################################################
    ### MemoryRepository

    module MemoryRepository
      def self.included(model)
        DataMapper.setup(:memory, "sqlite3::memory:") 
        model.send :include, self
        model.send :extend,  self
        super
      end

      # force repository
      def repository(name = nil)
        DataMapper.repository(name || :memory)
      end
    end

  end
end
