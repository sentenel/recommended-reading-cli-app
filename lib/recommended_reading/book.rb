class RecommendedReading::Book
  attr_accessor :isbn, :title, :author, :summary, :genres, :ratings, :quotes

  def initialize(isbn)
    self.isbn = isbn
    #Scrape information from "https://www.goodreads.com/book/isbn/#{isbn}"
  end

  def average_rating

  end

  def total_reviews

  end
end
