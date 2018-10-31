class RecommendedReading::ListScraper

  def self.scrape_nyt_bestsellers
    doc = Nokogiri::HTML(open("https://www.nytimes.com/books/best-sellers/combined-print-and-e-book-fiction/"))
    book_containers = doc.css("article.book")
    Array.new.tap do |books|
      book_containers.each do |container|
        books << {
          title: container.at("h2.title").text,
          link: container.at("button")["data-amazon"]
        }
      end
    end
  end

  def self.scrape_amazon_bestsellers
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

  def self.scrape_barnes_and_noble_bestsellers
    homepage = Nokogiri::HTML(open("https://www.barnesandnoble.com"))
    top_100 = "https://www.barnesandnoble.com" + homepage.at("div.top100-dark-on-gray a.btn--tile-top100")['href']
    doc = Nokogiri::HTML(open(top_100))
    book_containers = doc.css("div.product-info-listView")
    Array.new.tap do |books|
      book_containers.each do |container|
        books << {
          title: container.at("a").text,
          link: "https://www.barnesandnoble.com" + container.at("a")['href']
        }
      end
    end
  end

  def self.scrape_publishers_weekly
    doc = Nokogiri::HTML(open("https://www.publishersweekly.com/pw/nielsen/top100.html"))
    book_containers = doc.css("td.nielsen-bookinfo")
    Array.new.tap do |books|
      book_containers.each do |container|
        books << {
          title: container.at("div.nielsen-booktitle").text.strip,
          isbn: container.at("div.nielsen-isbn").text[/\d+-\d+-\d+-\d+-\d+/].gsub('-', '')
        }
      end
    end
  end

end
