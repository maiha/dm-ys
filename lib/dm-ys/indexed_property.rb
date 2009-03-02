module DataMapper
  module YunkerStar

    # ==== Example
    #
    #   Class Foo
    #     include DataMapper::YunkerStar
    #     property :id, Serial
    #
    #   foo = Foo.new
    #   foo[0] == foo[:id] == foo["id"] == foo.attributes[:id]

    class InvalidIndex < RuntimeError; end

    module IndexedProperty
      def [](key)
        case key
        when Integer
          self[properties.map(&:name)[key]]
        when String
          attributes[key.intern]
        when Symbol
          attributes[key]
        else
          raise InvalidIndex, "expected Integer/String/Symbol, but got #{key.class}"
        end
      end
    end

  end
end
