module DataMapper
  module YunkerStar

    ######################################################################
    ### Scrape html

    require 'nkf'
    require 'open-uri'
    require 'hpricot'

    class Scraper
      include CachedAccessor

      class TableNotFound < RuntimeError; end

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

      attr_reader :html

      def initialize(model)
        raise ArgumentError, "missing model" unless model
        raise ArgumentError, "missing uri"   unless model.uri
        @model = model
        @html  = NKF.nkf('-w', open(model.uri).read)
        @invalid_name_count = 0
      end

      def guess_table
        max_table or
          raise TableNotFound, "set 'table' or 'tbody' manually"
      end

      def links
        (doc / "a").map{|i| i[:href]}
      end

      def inspect
        attrs = [
          [ :html,      "#{html.size}bytes" ],
          [ :names,     names ],
          [ :entries,   entries.size ],
        ]
        "#<#{self.class.name} #{attrs.map { |(k,v)| "@#{k}=#{v.inspect}" } * ' '}>"
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
  end
end
