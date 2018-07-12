class RecommendedReading::BookScraper

  def scrape_goodreads(isbn)
    doc = Nokogiri::HTML(open("https://www.goodreads.com/book/isbn/#{isbn}"))
  end

end
