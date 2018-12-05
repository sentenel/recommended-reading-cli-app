class RecommendedReading::Book
  attr_accessor :link, :isbn, :title, :authors, :summary, :genres, :ratings, :reviews, :recommendations
  @@all = []

  def initialize
    @@all << self
  end

  def average_rating
    if ratings.length > 0
      weighted = ratings.map.with_index {|rating, index| rating * (5 - index)}.reduce(:+)
      (weighted / ratings.reduce(:+).to_f).round(2)
    else
      "No ratings available"
    end
  end

  def reviews
    @reviews ||= RecommendedReading::BookScraper.scrape_goodreads_reviews(isbn)
  end

  def self.new_from_goodreads(isbn)
    if book = @@all.detect {|book| book.isbn == isbn}
      book
    else
      book_hash = RecommendedReading::BookScraper.scrape_goodreads_isbn(isbn)
      create_book(book_hash, isbn: isbn)
    end
  end

  def self.new_from_goodreads_link(link)
    if book = @@all.detect {|book| book.link == link}
      book
    else
      book_hash = RecommendedReading::BookScraper.scrape_goodreads(link)
      create_book(book_hash, link: link)
    end
  end

  def self.new_from_barnes_and_noble(link)
    if book = @@all.detect {|book| book.link == link}
      book
    else
      book_hash = RecommendedReading::BookScraper.scrape_from_barnes_and_noble_link(link)
      create_book(book_hash, link: link)
    end
  end

  def self.new_from_publishers_weekly(isbn)
    if book = @@all.detect {|book| book.isbn == isbn}
      book
    else
      book_hash = RecommendedReading::BookScraper.scrape_from_publishers_weekly(isbn)
      create_book(book_hash, isbn: isbn)
    end
  end

  private

  def self.create_book(book_hash, isbn: nil, link: nil)
    self.new.tap do |book|
      book.isbn = isbn
      book.link = link
      book_hash.each {|key, value| book.send("#{key}=", value)}
    end
  end

end
