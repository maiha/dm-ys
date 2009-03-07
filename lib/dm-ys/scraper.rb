module DataMapper
  module YS

    ######################################################################
    ### Scrape html

    require 'nkf'
    require 'open-uri'
    require 'hpricot'
    require 'digest/sha1'

    module Scraper
      class TableNotFound < RuntimeError; end

      def self.paginate?(model)
        model.uri.to_s[-1] == ?*
      end

      def self.lookup(model)
        scraper = paginate?(model) ? Composite : Page
        scraper.new(model)
      end

      def self.load(model)
        loader = lookup(model)
        loader.register_properties!
        return loader
      end

      ######################################################################
      ### Utils

      module Utils
        def constantize(label)
          require 'cgi'
          label = CGI.unescapeHTML(label.to_s)
          label.gsub!(/&[a-z]+;/, '')
          label.gsub!(/\r?\n/, '')
          label.gsub!(/\s+/,'')
          label.delete!('!"#$%&()=~|`{}^-[]/<>:;,.\\-')
          label.delete!("'")
          return label
        end

        module_function :constantize
      end

      ######################################################################
      ### Base Scraper

      class Base
        include CachedAccessor

        def initialize(model, *args)
          raise ArgumentError, "missing model" unless model
          raise ArgumentError, "missing uri"   unless model.uri
          @model = model
        end
        [:names, :labels, :entries].each do |method|
          define_method(method) {raise NotImplementedError, method.to_s}
        end

        def count
          entries.size
        end

        def uri
          @uri || @model.uri.to_s.chomp('*')
        end

        def register_properties!
          names.each do |name|
            type = String         # TODO
            @model.property name.intern, type
          end
        end
      end

      ######################################################################
      ### Page Scraper

      class Page < Base
        attr_reader :html

        def initialize(model, uri = nil)
          super
          @uri  = uri
          @html = NKF.nkf('-w', open(self.uri).read)
          @invalid_name_count = 0
        end

        def guess_table
          max_table or
            raise TableNotFound, "set 'table' or 'tbody' manually"
        end

        def pagination_links
          base = URI.parse(uri.split('?').first)
          urls = (doc / "a").map{|i| i[:href] =~ /^http/ ? i[:href] : (base+i[:href]).to_s}.uniq
          urls.select{|url| /^#{Regexp.escape(base.to_s)}/ === url}
        end

        def inspect
          attrs = [
            [ :html,      "#{html.size}bytes" ],
            [ :names,     names ],
            [ :entries,   count ],
          ]
          "#<#{self.class.name} #{attrs.map { |(k,v)| "@#{k}=#{v.inspect}" } * ' '}>"
        end

        def page_hash
          body = entries.flatten.join("\t")
          Digest::SHA1.hexdigest(body)
        end

        cached_accessor do
          doc     {Hpricot(@html)}
          table   {specified(:table) or guess_table}
          thead   {specified(:thead) or table.search("> thead").first or table}
          tbody   {specified(:tbody) or table.search("> tbody").first or table}
          names   {labels.map{|i| label2name(i)}}
          labels  {thead.search("> tr").first.search("> td|th").map{|i|strip_tags(i.inner_html)}}
          entries {tbody.search("> tr").map{|tr| tr.search("> td").map{|i|strip_tags(i.inner_html)}}.delete_if{|i|i.blank?}}
        end

        private

          def max_table
            table = nil
            count = -1
            doc.search("table").each do |t|
              size = [t.search("> tr").size, t.search("> tbody > tr").size].max
              if size > count
                count = size
                table = t
              end
            end
            return table
          end

          def specified(name)
            @model.respond_to?(name)    or raise ArgumentError, "invalid selector name: #{name}"
            css = @model.__send__(name) or return nil

            element = doc.search(css)
            case element
            when Hpricot::Elem
              return element
            when Hpricot::Elements
              return element.first
            else
              return nil
            end
          end

          def label2name(label)
            label = Utils.constantize(label)

            if /^([A-Z])/ === label and Object.const_defined?(label)
              label = "_#{label}"
            end
            if label.blank? or @model.respond_to?(label, true)
              new_name_for(label)
            elsif /^[0-9]/ === label
              "_#{label}"
            else
              label
            end
          end

          def new_name_for(label)
            @invalid_name_count += 1
            "col_#{@invalid_name_count}"
          end

          def strip_tags(html)
            html.gsub(/<.*?>/, '').strip
          end
      end

      ######################################################################
      ### Composite Scraper

      class Composite < Base
        def pages
          @pages ||= execute
        end

        def names
          pages.first.names
        end

        def labels
          pages.first.labels
        end

        def entries
          records = []
          digests = Set.new
          pages.each do |page|
            page.entries.each do |entry|
              if config.uniq_entry?
                sha1 = Digest::SHA1.hexdigest(entry.join("\t"))
                next if digests.include?(sha1)
                digests << sha1
              end
              records << entry
            end
          end
          return records
        end

        private
          def execute
            visit(uri)
            uniq_pages
          end

          def config
            @model.ys
          end

          def uniq_pages
            return loaded_pages unless config.uniq_page?

            digests = Set.new
            loaded_pages.select do |page|
              sha1 = page.page_hash
              if digests.include?(sha1)
                false
              else
                digests << sha1
                true
              end
            end
          end

          def loaded_pages
            loaded_pages_hash.values.compact
          end

          def loaded_pages_hash
            @loaded_pages_hash ||= {} # url => page object
          end

          def visit(uri, runtime_options = {:count => 0})
            return if loaded_pages_hash[uri]
            raise Proxy::MaxPagesOverflow if (runtime_options[:count]+=1) > @model.ys[:max_pages]
            
            page = Page.new(@model, uri)
            base = loaded_pages.first
            if !base or base.names == page.names
              loaded_pages_hash[uri] = page
            else
              loaded_pages_hash[uri] = nil
            end
            page.pagination_links.each{|uri| visit(uri, runtime_options)}
          end
      end

    end
  end
end
