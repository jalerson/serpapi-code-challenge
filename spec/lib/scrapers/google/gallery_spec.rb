require 'nokolexbor'
require 'scrapers/google/gallery'
require 'json'

RSpec.describe Scrapers::Google::Gallery do
  let(:parser) { Nokolexbor }

  describe '#scrape' do
    context 'Van Gogh artwork' do
      let(:scraper) { described_class.new(parser: parser) }

      it 'scrapes the artwork' do
        input_file_content = File.read(File.join(__dir__, '../../../../files/van-gogh-paintings.html'))
        expected_file_content = File.read(File.join(__dir__, '../../../../files/expected-array.json'))
        expected_artworks = JSON.parse(expected_file_content, symbolize_names: true)
        
        artworks = scraper.scrape(input_file_content)
        expect({artworks: artworks}).to eq(expected_artworks)
      end
    end

    context 'Picasso paintings' do
      let(:scraper) { described_class.new(parser: parser) }

      it 'scrapes the paintings' do
        input_file_content = File.read(File.join(__dir__, '../../../fixtures/picasso-paintings.html'))
        expected_file_content = File.read(File.join(__dir__, '../../../fixtures/expected-picasso-paintings.json'))
        expected_artworks = JSON.parse(expected_file_content, symbolize_names: true)
        
        artworks = scraper.scrape(input_file_content)

        expect({artworks: artworks}).to eq(expected_artworks)
      end
    end

    context 'Steve McCurry photos' do
      let(:scraper) { described_class.new(parser: parser) }

      it 'scrapes the paintings' do
        input_file_content = File.read(File.join(__dir__, '../../../fixtures/steve-mccurry-photos.html'))
        expected_file_content = File.read(File.join(__dir__, '../../../fixtures/expected-steve-mccurry-photos.json'))
        expected_artworks = JSON.parse(expected_file_content, symbolize_names: true)
        
        photos = scraper.scrape(input_file_content)
        expect({photos: photos}).to eq(expected_artworks)
      end
    end
  end
end