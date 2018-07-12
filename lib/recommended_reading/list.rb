class RecommendedReading::List
  attr_accessor :books

  def initialize
    self.books = []
  end

  def add_book(book)
    self.books << book
  end

  def titles
  end

end
