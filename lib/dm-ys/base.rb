module DataMapper
  module YS
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
      name = 'YS'
      model.send :include, DataMapper::Resource
      model.send :include, Proxy
      model.send :include, IndexedProperty
      model.send :include, ElementProperty
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
      klass = Class.new
      klass.class_eval do
        include DataMapper::YS
        self.uri uri
      end
      return klass
    end
  end
end
