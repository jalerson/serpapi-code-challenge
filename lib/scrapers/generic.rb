module Scrapers
  class Generic
    attr_accessor :selector, :processor

    DEFAULT_PROCESSOR_FN = ->(item) { item.text }

    def initialize(selector:, processor: DEFAULT_PROCESSOR_FN)
      @selector = selector
      @processor = processor
    end

    def scrape(html)
      @processor.call(html.css(@selector))
    end
  end
end