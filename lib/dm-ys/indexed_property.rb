module DataMapper
  module YS

    # ==== Example
    #
    #   Class Foo
    #     include DataMapper::YS
    #     property :id, Serial
    #
    #   foo = Foo.new
    #   foo[0] == foo[:id] == foo["id"] == foo.attributes[:id]

    class InvalidIndex < RuntimeError; end

    module IndexedProperty
      def normalized_property_for(key)
        case key
        when Integer
          properties.map(&:name)[key]
        when String
          key.intern
        when Symbol
          key
        else
          raise InvalidIndex, "expected Integer/String/Symbol, but got #{key.class}"
        end
      end

      def [](key)
        attributes[normalized_property_for(key)]
      end
    end

  end
end
