require 'nokolexbor'
require 'scrapers/google/image_replacer_script'

RSpec.describe Scrapers::Google::ImageReplacerScript do
  let(:replacer) { described_class.new }

  describe '#initialize' do
    context 'using the default values' do
      it 'creates a scraper using the default values' do
        expect(replacer.selector).to eq(described_class::DEFAULT_SELECTOR)
        expect(replacer.image_replacer_fn).to eq(described_class::IMAGE_REPLACER_FN)
      end
    end

    context 'using a custom selector and func name' do
      it 'creates a scraper using custom values' do
        scraper = described_class.new(selector: 'div.sample', image_replacer_fn: 'myFunc')

        expect(scraper.selector).to eq('div.sample')
        expect(scraper.image_replacer_fn).to eq('myFunc')
      end
    end
  end

  describe '#scrape' do
    context 'when html is nil' do
      it 'returns empty hash' do
        expect(replacer.scrape(nil)).to eq({})
      end
    end

    context 'with valid html' do
      let(:html) do
        Nokolexbor::HTML(<<~HTML)
          <html>
            <script nonce="xmO6un4J9murPFDygFfaMA">
              (function () { var s='base64data\\x3d\\x3d';var ii=['image1'];var r='';_setImagesSrc(ii, s, r); })();
            </script>
            <script nonce="xmO6un4J9murPFDygFfaMA">
              (function () { var s='otherdata\\x3d';var ii=['image2'];var r='';_setImagesSrc(ii, s, r); })();
            </script>
          </html>
        HTML
      end

      it 'extracts image mappings' do
        expected = {
          'image1' => 'base64data==',
          'image2' => 'otherdata='
        }
        expect(replacer.scrape(html)).to eq(expected)
      end
    end

    context 'with custom function name' do
      let(:replacer) { described_class.new(image_replacer_fn: '_customFn') }
      let(:html) do
        Nokolexbor::HTML(<<~HTML)
          <html>
            <script nonce="xmO6un4J9murPFDygFfaMA">
              (function () { var s='testdata\\x3d';var ii=['image3'];var r='';_customFn(ii, s, r); })();
            </script>
          </html>
        HTML
      end

      it 'scrapes the correct data' do
        expect(replacer.scrape(html)).to eq({'image3' => 'testdata='})
      end
    end

    context 'with no matching script' do
      let(:html) { Nokolexbor::HTML('<html><script>other code</script></html>') }
      
      it 'returns empty hash' do
        expect(replacer.scrape(html)).to eq({})
      end
    end
  end
end