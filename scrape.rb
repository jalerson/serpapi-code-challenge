require 'nokogiri'
require 'nokolexbor'
require 'json'

require_relative 'lib/scrapers/google/gallery'

input_file = ARGV[0] || './files/van-gogh-paintings.html'
parser_name = ARGV[1] || 'output.json'

case parser_name
when 'nokolexbor'
  html_parser = Nokolexbor
when 'nokogiri'
  html_parser = Nokogiri
else
  html_parser = Nokolexbor
end

scraper = Scrapers::Google::Gallery.new(parser: html_parser)

html = File.read(input_file)
artworks = scraper.scrape(html)

output = {artworks: artworks}
puts output.to_json