class RecommendedReading::List
  attr_accessor :books, :title

  def initialize
    self.books = []
  end

  def add_book(book)
    self.books << book
  end

  def book_titles
    books.map {|book| book.title}
  end

end
