class RecommendedReading::List < Array
  attr_accessor :list_source

  def initialize(list_source)
    self.list_source = list_source
  end

  def book_titles
    self.map {|book| book.title}
  end

  def self.new_from_amazon
    self.new("Amazon").tap do |list|
      RecommendedReading::ListScraper.scrape_amazon_bestsellers.each {|book| list << book}
    end
  end
  
end