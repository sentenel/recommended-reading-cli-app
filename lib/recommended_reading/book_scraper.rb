require 'pry'
class RecommendedReading::BookScraper

  def scrape_goodreads(isbn)
    doc = Nokogiri::HTML(open("https://www.goodreads.com/book/isbn/#{isbn}"))
    binding.pry
    #title: doc.css('h1.bookTitle').text.strip
    #authors: doc.css('div#bookAuthors').text.gsub(/( by)*?/, '').strip
    #summary: doc.css('div#description').text.gsub(/\.\.\.more/, '').strip
  end

end
