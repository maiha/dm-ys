module DataMapper
  module YS

    # ==== Example
    #
    #   Class Foo
    #     include DataMapper::YS
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
          dsl_accessor :ys, :default=>proc{|*a| DataMapper::YS::Config.new}
          property :id, DataMapper::Types::Serial
        end
      end

      class MaxPagesOverflow < RuntimeError; end

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

        def records
          @records ||= (proxy.records.each_with_index{|r,i| r.id = i+1}; proxy.records)
        end

        def count
          records.size
        end

        def all
          records
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
