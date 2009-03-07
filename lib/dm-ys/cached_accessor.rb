module DataMapper
  module YS
    ######################################################################
    ### CachedAccessor

    module CachedAccessor
      def self.included(klass)
        def klass.cached_accessor(&block)
          Thread.current[:cached_accessor] = true
          Define.new(self, &block)
        ensure
          Thread.current[:cached_accessor] = false
        end
        super
      end

      class Define
        def initialize(klass, &block)
          @klass = klass
          instance_eval(&block)
        end

        def method_missing(symbol, &block)
          cached = "__cached__#{symbol}"
          @klass.send(:define_method, cached, &block)
          @klass.class_eval("def #{symbol}; @#{cached} ||= #{cached}; end", "(__CACHED_ACCESSOR__)", 1)
        end
      end
    end

  end
end
