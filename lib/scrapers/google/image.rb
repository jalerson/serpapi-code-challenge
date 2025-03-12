module Scrapers
  module Google
    class Image
      DEFAULT_SELECTOR = 'img.taFZJe'.freeze
      PLACEHOLDER = 'data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='.freeze

      attr_accessor :selector, :image_map

      def initialize(selector: DEFAULT_SELECTOR)
        @selector = selector
      end

      def scrape(html)
        images = html.css(@selector)
        return if images.empty?
        image = images[0]

        image_src = image.attributes['src']&.text
        image_url = image_src
        image_data_src = image.attributes['data-src']&.text

        if image_data_src
          image_url = image_data_src
        elsif image_src == PLACEHOLDER
          image_id = image.attributes['id']&.text
          image_url = image_map[image_id] if image_map&.key?(image_id)
        end

        image_url
      end
    end
  end
end