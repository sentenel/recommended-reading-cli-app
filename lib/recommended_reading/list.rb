class RecommendedReading::List < Array
  attr_accessor :list_source

  def initialize(list_source)
    self.list_source = list_source
  end

  def book_titles
    self.map {|book| book.title}
  end


  def get_book(index)
    case list_source
    when 'Barnes and Noble', 'NYT'
      RecommendedReading::Book.new_from_barnes_and_noble(self[index][:link])
    when 'Publishers Weekly'
      RecommendedReading::Book.new_from_publishers_weekly(self[index][:isbn])
    when 'Recommendations'
      RecommendedReading::Book.new_from_goodreads_link(self[index][:link])
    end
  end

  def self.new_from_nyt
    RecommendedReading::ListScraper.scrape_nyt_bestsellers
  end

  def self.new_from_barnes_and_noble
    RecommendedReading::ListScraper.scrape_barnes_and_noble_bestsellers
  end

  def self.new_from_publishers_weekly
    RecommendedReading::ListScraper.scrape_publishers_weekly
  end

end
