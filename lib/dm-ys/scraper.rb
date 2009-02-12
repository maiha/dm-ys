module DataMapper
  module YunkerStar

    ######################################################################
    ### Scrape html

    require 'nkf'
    require 'open-uri'
    require 'hpricot'

    class Scraper
      include CachedAccessor

      def initialize(model)
        @model = model
        @html  = NKF.nkf('-w', open(@model.uri).read)
      end

      cached_accessor do
        doc     {Hpricot(@html)}
        labels  {doc.search(@model.thead).first.children.map(&:inner_html)}
        entries {doc.search(@model.tbody).map{|tr| tr.children.map(&:inner_html)}}
      end
    end

  end
end
