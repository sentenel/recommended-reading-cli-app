class RecommendedReading::ListScraper

  def scrape_nyt_bestsellers
  end

  def scrape_amazon_bestsellers
    list_length = 20
    doc = Nokogiri::HTML(open("https://www.amazon.com/bestsellers/books"))
    Array.new.tap do |books|
      (0..list_length-1).each do |index|
      books << {
        title: doc.css("div.p13n-sc-truncate.p13n-sc-line-clamp-1")[index].text.strip,
        link: "https://www.amazon.com" + doc.xpath("//span[@class='a-size-base a-color-price']/..")[index]['href']
      }
      end
    end
  end

  def scrape_barnes_and_noble_bestsellers
  end

  def scrape_publishers_weekly
  end

end
