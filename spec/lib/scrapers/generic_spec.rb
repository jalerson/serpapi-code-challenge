require 'nokolexbor'
require 'scrapers/generic'

RSpec.describe Scrapers::Generic do
  let(:html) { Nokolexbor::HTML('<div class="sample">Hello World</div>') }
  let(:selector) { '.sample' }

  describe '#initialize' do
    it 'creates an instance of the scraper' do
      scraper = described_class.new(selector: selector)
      expect(scraper.processor).to eq(described_class::DEFAULT_PROCESSOR_FN)
    end
    
    context 'when using a custom processor' do
      it 'creates the scraper using the customer processor' do
        custom_processor = ->(item) { item.text.upcase }
        scraper = described_class.new(selector: selector, processor: custom_processor)
        
        expect(scraper.selector).to eq(selector)
        expect(scraper.processor).to eq(custom_processor)
      end
    end
  end

  describe '#scrape' do
    context 'using the default processor' do
      it 'scrapes the content using the selector and the default processor' do
        scraper = described_class.new(selector: selector)

        expect(scraper.scrape(html)).to eq('Hello World')
      end
    end

    context 'using a custom processor' do
      it 'scrapes the content using the custom processor' do
        custom_processor = ->(item) { item.text.upcase }
        scraper = described_class.new(selector: selector, processor: custom_processor)

        expect(scraper.scrape(html)).to eq('HELLO WORLD')
      end
    end
  end
end