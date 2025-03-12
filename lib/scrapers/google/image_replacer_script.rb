module Scrapers
  module Google
    class ImageReplacerScript
      DEFAULT_SELECTOR = "script".freeze
      IMAGE_REPLACER_FN = "_setImagesSrc".freeze
      IMAGE_DATA_PATTERN = /s='(.*?)';.*?var ii=\['(.*?)'\]/

      attr_accessor :selector, :image_replacer_fn

      def initialize(selector: DEFAULT_SELECTOR, image_replacer_fn: IMAGE_REPLACER_FN)
        @selector = selector
        @image_replacer_fn = image_replacer_fn
      end

      def scrape(html)
        return {} if html.nil?

        scrape_image_map(scrape_image_replacer_script(html))
      end

      private
      
      def scrape_image_replacer_script(html)
        html.css(@selector)
          .select { |script| script.text.include?(@image_replacer_fn) }
          .map(&:text)
          .join
      end
      
      def scrape_image_map(script)
        return {} if script.empty?
        
        matches = script.scan(IMAGE_DATA_PATTERN)
        return {} if matches.empty?
        
        image_map = {}
        matches.each do |base64, image_id|
          image_map[image_id] = sanitize(base64)
        end

        image_map
      end

      def sanitize(base64)
        base64.gsub(/\\x3d/, "=")
      end
    end
  end
end