class RecommendedReading::Book
  attr_accessor :isbn, :title, :author, :summary, :genres, :ratings, :quotes, :reviews

  def initialize(isbn)
    self.isbn = isbn
    #Scrape information from "https://www.goodreads.com/book/isbn/#{isbn}"
  end

  def average_rating
    if ratings.length > 0
      combined = ratings.inject([0, 0]) {|total, rating| [total[0] + rating[0] * rating[1], total[1] + rating[1]]}
      (combined[0] / combined[1].to_f).round(2)
    else
      "No ratings available"
    end
  end

  def total_ratings
    ratings.each {|rating| puts "#{rating[0]} star ratings: #{rating[1]}"}
    puts "Total ratings: #{ratings.inject(0){|total, rating| total + rating[1]}}"
  end
end
