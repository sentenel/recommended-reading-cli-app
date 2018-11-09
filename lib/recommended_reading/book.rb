class RecommendedReading::Book
  attr_accessor :isbn, :title, :authors, :summary, :genres, :ratings, :reviews, :recommendations

  def average_rating
    if ratings.length > 0
      weighted = ratings.map.with_index {|rating, index| rating * (5 - index)}.reduce(:+)
      (weighted / ratings.reduce(:+).to_f).round(2)
    else
      "No ratings available"
    end
  end

  def display_total_ratings
    ratings.each_with_index {|number, index| puts "#{5-index} star ratings: #{number}"}
    puts "Total ratings: #{ratings.reduce(:+)}"
  end

  def reviews
    reviews ||= RecommendedReading::BookScraper.scrape_goodreads_reviews(isbn)
  end

  def self.new_from_goodreads(isbn)
    book_hash = RecommendedReading::BookScraper.scrape_goodreads_isbn(isbn)
    create_book(book_hash)
  end

  def self.new_from_goodreads_link(link)
    book_hash = RecommendedReading::BookScraper.scrape_goodreads(link)
    create_book(book_hash)
  end

  def self.new_from_barnes_and_noble(link)
    book_hash = RecommendedReading::BookScraper.scrape_from_barnes_and_noble_link(link)
    create_book(book_hash)
  end

  def self.new_from_publishers_weekly(isbn)
    book_hash = RecommendedReading::BookScraper.scrape_from_publishers_weekly(isbn)
    create_book(book_hash)
  end

  private

  def self.create_book(book_hash)
    self.new.tap do |book|
      book_hash.each {|key, value| book.send("#{key}=", value)}
    end
  end

end
