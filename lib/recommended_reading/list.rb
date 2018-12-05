class RecommendedReading::List
  attr_accessor :list_source, :books
  @@all = []

  def initialize(list_source)
    @list_source = list_source
    @books = []
    @@all << self
  end

  def get_book(index)
    case list_source
    when 'Barnes and Noble', 'NYT'
      RecommendedReading::Book.new_from_barnes_and_noble(@books[index][:link])
    when 'Publishers Weekly'
      RecommendedReading::Book.new_from_publishers_weekly(@books[index][:isbn])
    when 'Recommendations'
      RecommendedReading::Book.new_from_goodreads_link(@books[index][:link])
    end
  end

  def self.new_from_nyt
    @@all.find {|list| list.list_source == 'NYT'} || RecommendedReading::ListScraper.scrape_nyt_bestsellers
  end

  def self.new_from_barnes_and_noble
    @@all.find {|list| list.list_source == 'Barnes and Noble'} || RecommendedReading::ListScraper.scrape_barnes_and_noble_bestsellers
  end

  def self.new_from_publishers_weekly
    @@all.find {|list| list.list_source == 'Publishers Weekly'} || RecommendedReading::ListScraper.scrape_publishers_weekly
  end

end
