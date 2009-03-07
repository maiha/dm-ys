module DataMapper
  module YunkerStar
    class Config
      def self.default
        {:max_pages=>100, :uniq=>true}
      end
 
      def initialize(options = nil)
        @options = options
        @options = self.class.default unless @options.is_a?(Hash)
      end

      def [](key)
        @options[key]
      end

      def []=(key, val)
        @options[key] = val
      end

      def uniq_page?
        !!self[:uniq]
      end

      def uniq_entry?
        self[:uniq] == true or self[:uniq] == :entry
      end
    end
  end
end
