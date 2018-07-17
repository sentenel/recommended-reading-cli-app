class RecommendedReading::Book
  attr_accessor :isbn, :title, :authors, :summary, :genres, :ratings, :reviews

  def initialize(isbn)
    self.isbn = isbn
  end

  def average_rating
    if ratings.length > 0
      weighted = ratings.map.with_index {|rating, index| rating * (5 - index)}.reduce(:+)
      (weighted / ratings.reduce(:+).to_f).round(2)
    else
      "No ratings available"
    end
  end

  def total_ratings
    ratings.each_with_index {|number, index| puts "#{5-index} star ratings: #{number}"}
    puts "Total ratings: #{ratings.reduce(:+)}"
  end

  def reviews
    reviews ||= RecommendedReading::BookScraper.scrape_goodreads_reviews(isbn)
  end

  def self.new_from_goodreads(isbn)
    book_hash = RecommendedReading::BookScraper.scrape_goodreads(isbn)
    self.new(isbn).tap do |book|
      book_hash.each {|key, value| book.send("#{key}=", value)}
    end
  end

end
