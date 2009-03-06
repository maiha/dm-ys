module DataMapper
  module YunkerStar

    # ==== Example
    #
    #   Class Foo
    #     include DataMapper::YunkerStar
    #
    #     uri   "http://ds.gkwiki2.com/47.html"
    #     thead "table.style_table thead tr"
    #     tbody "table.style_table tbody tr"

    module Proxy
      def self.included(model)
        model.class_eval do
          extend ClassMethods
          dsl_accessor :uri
          dsl_accessor :table
          dsl_accessor :tbody
          dsl_accessor :thead
          property :id, DataMapper::Types::Serial
        end
      end

      module ClassMethods
        def proxy
          @proxy ||= Scraper.load(self)
        end

        def names
          proxy.names
        end

        def labels
          proxy.labels
        end

        def entries
          proxy.entries
        end

        def count
          entries.size
        end

        def all
          count = 0
          @all ||= entries.map{|array|
            count += 1
            new(Hash[*names.zip(array).flatten].merge(:id=>count))
          }
        end

        def first
          all.first
        end

        def last
          all.last
        end

        def get(*ids)
          if ids.size == 1 and !ids.first.is_a?(Array)
            all[ids.to_i]
          else
            ids.map{|id| get(id)}
          end
        end
      end
    end

  end
end
