module DataMapper
  module YunkerStar
    # @api public
    def self.append_inclusions(*inclusions)
      extra_inclusions.concat inclusions
      true
    end

    def self.extra_inclusions
      @extra_inclusions ||= []
    end

    # @api private
    def self.included(model)
      name = 'YunkelStar'
      model.send :include, DataMapper::Resource
      model.send :include, Proxy
      model.send :include, IndexedProperty
      # model.send :include, MemoryRepository
      model.const_set(name, self) unless model.const_defined?(name)
      extra_inclusions.each { |inclusion| model.send(:include, inclusion) }
      descendants << model
    end

    # @api semipublic
    def self.descendants
      @descendants ||= Set.new
    end

    # @api public
    def self.[](uri)
      klass = Class.new do
        include DataMapper::YunkerStar
      end
      klass.uri uri
      return klass
    end
  end
end
