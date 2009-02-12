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

      attr_reader :html

      def initialize(model)
        raise ArgumentError, "missing model" unless model
        raise ArgumentError, "missing uri"   unless model.uri
        @model = model
        @html  = NKF.nkf('-w', open(model.uri).read)
        @invalid_name_count = 0
      end

      def guess_table
        [max_table_from("table"), max_table_from("table > tbody")].sort_by(&:first).last.last or
          raise TableNotFound, "set 'table' or 'tbody' manually"
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

        def max_table_from(entry)
          table = nil
          count = -1
          doc.search(entry).each do |t|
            size = t.search("> tr").size
            if size > count
              count = size
              table = t
            end
          end
          [count, table]
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
          require 'cgi'
          label = CGI.unescapeHTML(label)
          label.gsub!(/&nbsp;/, '')
          label.gsub!(/\r?\n/, '')
          label.delete!('!"#$%&()=~|`{}^-[]/<>:; \\')
          label.delete!("'")
          label.strip!

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
