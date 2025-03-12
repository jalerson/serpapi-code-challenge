require 'nokolexbor'
require 'scrapers/google/image'

RSpec.describe Scrapers::Google::Image do
  let(:scraper) { described_class.new }
  let(:html) { Nokolexbor::HTML(html_content) }

  describe '#initialize' do
    context 'with the default selector' do
      it 'creates a scraper using the default selector' do
        scraper = described_class.new

        expect(scraper.selector).to eq(described_class::DEFAULT_SELECTOR)
      end
    end

    context 'with a custom selector' do
      it 'creates a scraper using the custom selector' do
        scraper = described_class.new(selector: '.custom-class')

        expect(scraper.selector).to eq('.custom-class')
      end
    end
  end

  describe '#scrape' do
    context 'when no matching images found' do
      let(:html_content) { '<div>No images here</div>' }
      
      it 'returns nil' do
        expect(scraper.scrape(html)).to be_nil
      end
    end

    context 'with regular image src' do
      let(:html_content) { '<img class="taFZJe" src="image.jpg">' }
      
      it 'returns the src url' do
        expect(scraper.scrape(html)).to eq('image.jpg')
      end
    end

    context 'with data-src attribute' do
      let(:html_content) { '<img class="taFZJe" src="placeholder.jpg" data-src="real-image.jpg">' }
      
      it 'returns the data-src url' do
        expect(scraper.scrape(html)).to eq('real-image.jpg')
      end
    end

    context 'with placeholder image' do
      let(:html_content) { "<img class=\"taFZJe\" id=\"img1\" src=\"#{described_class::PLACEHOLDER}\">" }
      
      before do
        scraper.image_map = {'img1' => 'mapped-image.jpg'}
      end

      it 'returns mapped image url' do
        expect(scraper.scrape(html)).to eq('mapped-image.jpg')
      end
    end
  end
end