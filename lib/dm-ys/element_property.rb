module DataMapper
  module YS

    # ==== Example
    #
    #   Class Foo
    #     include DataMapper::YS
    #     uri ...
    #
    #   # <tr><th>name</th>...
    #   # <tr><td><a href="/plugins/36">dm-ys</a></td>...
    #
    #   foo = Foo.first
    #   foo.link_for(:name) # => "/plugins/36"

    module ElementProperty
      def link_for(key)
        links_for(key).first
      end

      def links_for(key)
        key = normalized_property_for(key)
        (@links[key.to_s] || []).map do |url|
          if self.class.ys.only_path?
            url
          else
            (self.class.proxy.base_uri + url).to_s
          end
        end
      end

      def element_for(key)
        key = normalized_property_for(key)
        @elements[key.to_s]
      end

      def links=(value)
        @links = value
      end

      def elements=(value)
        @elements = value
      end
    end

  end
end
