require_relative 'image'
require_relative 'image_replacer_script'
require_relative '../generic'

module Scrapers
  module Google
    class Gallery
      DEFAULT_SELECTOR = 'div.iELo6'.freeze
      DEFAULT_SCRAPERS = {
        name: Scrapers::Generic.new(selector: 'div.pgNMRc'),
        extensions: Scrapers::Generic.new(selector: 'div.cxzHyb', processor: ->(div) { div.text.empty? ? nil : [div.text] }),
        link: Scrapers::Generic.new(selector: 'a', processor: -> (links) { 'https://www.google.com' + links[0]&.attributes['href']&.text }),
        image: Scrapers::Google::Image.new
      }
      DEFAULT_SCRIPT_SCRAPER = Scrapers::Google::ImageReplacerScript

      def initialize(parser:, selector: DEFAULT_SELECTOR, scrapers: DEFAULT_SCRAPERS, script_scraper: DEFAULT_SCRIPT_SCRAPER)
        @parser = parser
        @selector = selector
        @scrapers = scrapers
        @script_scraper = script_scraper.is_a?(Class) ? script_scraper.new : script_scraper
      end

      def scrape(input)
        html = @parser.HTML(input)

        output = []
        @scrapers[:image].image_map = @script_scraper.scrape(html)

        html.css(@selector).each do |item|
          output_item = {}

          @scrapers.each_pair do |key, scraper|
            value = scraper.scrape(item)
            output_item[key] = value if value
          end

          output << output_item
        end

        output
      end
    end
  end
end