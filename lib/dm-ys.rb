require 'set'

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
      model.send :include, Resource
      model.send :extend,  ClassMethods    if defined?(ClassMethods)
      model.send :include, InstanceMethods if defined?(InstanceMethods)
      model.const_set(name, self) unless model.const_defined?(name)
      extra_inclusions.each { |inclusion| model.send(:include, inclusion) }
      descendants << model
      model.class_eval do
        dsl_accessor :url
        dsl_accessor :tbody
        dsl_accessor :thead
        property :id, DataMapper::Types::Serial
      end

      # model.send :include, MemoryRepository
    end

    # @api semipublic
    def self.descendants
      @descendants ||= Set.new
    end

    # ==== Parameters
    # name<Symbol>:: name attribute to set
    # value<Type>:: value to store at that location
    #
    # ==== Returns
    # <Types>:: the value stored at that given attribute, nil if none, and default if necessary
    #
    # ==== Example
    #
    #   Class Foo
    #     include DataMapper::YunkerStar
    #
    #     url   "http://ds.gkwiki2.com/47.html"
    #     thead "table.style_table thead tr"
    #     tbody "table.style_table tbody tr"

    module ClassMethods
      def proxy
        @proxy ||= lazy_load
      end

      def lazy_load
        loader = Scraper.new(self)
        loader.labels.each do |name|
          type = String         # TODO
          property name.intern, type
        end
        return loader
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
        @all ||= proxy.entries.map{|array|
          new(Hash[*proxy.labels.zip(array).flatten])
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

    ######################################################################
    ### Scrape html

    require 'open-uri'
    require 'hpricot'

    class Scraper
      def self.read_html(url_or_string)
        url = (URI.parse(url_or_string.to_s).to_s == url_or_string.to_s) && url_or_string.to_s
        if url
          open(url).read
        else
          url_or_string
        end
      end

      def initialize(model)
        @model = model
        @html  = NKF.nkf('-w', self.class.read_html(@model.url))
      end

      def doc
        @doc ||= Hpricot(@html)
      end

      def labels
        @labels ||= doc.search(@model.thead).first.children.map(&:inner_html)
      end

      def entries
        @entries ||= doc.search(@model.tbody).map{|tr| tr.children.map(&:inner_html)}
      end
    end

  end
end
