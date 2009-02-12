module DataMapper
  module YunkerStar
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
          @klass.send(:define_method, symbol, &block)
        end
      end
    end

  end
end
