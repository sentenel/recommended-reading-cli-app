class RecommendedReading::BookScraper

  def self.scrape_goodreads(link)
    doc = Nokogiri::HTML(open(link))
    if !(doc.css("link[rel=canonical]").first['href'] == "https://www.goodreads.com/book")
      Hash.new.tap do |book|
        book[:isbn] = doc.at("//meta[@property='books:isbn']")['content']
        book[:title] = doc.css('h1#bookTitle').text.strip
        book[:authors] = doc.css('div#bookAuthors').text.gsub(/( by)*?/, '').strip.gsub(/by\n+/, '')
        book[:summary] = doc.css('div#description').text.gsub(/\.\.\.more/, '').strip
        book[:genres] = doc.css('div.left a.bookPageGenreLink').map {|element| element.text}.uniq
        ratings = doc.css('div#bookMeta script').first.children.first.content.scan(/\d+ ratings/)
        book[:ratings] = ratings.map {|total| total.gsub(/ ratings/, '').to_i}
        book[:recommendations] = scrape_goodreads_recommendations(doc)
      end
    else
      Hash.new
    end
  end

  def self.scrape_goodreads_isbn(isbn)
    scrape_goodreads("https://www.goodreads.com/book/isbn/#{isbn}")
  end

  def self.scrape_goodreads_reviews(isbn)
    doc = Nokogiri::HTML(open("https://www.goodreads.com/book/isbn/#{isbn}"))
    review_url_parts = doc.css("a:contains('see review')").map {|element| element['href']}
    Array.new.tap do |reviews|
      review_counter = 0
      review_url_parts.each do |url_part|
        review_page = Nokogiri::HTML(open('https://www.goodreads.com' + url_part))
        reviewer = review_page.at("//a[@itemprop = 'author']")
        opinion = review_page.at("span.staticStar")
        review_text = review_page.at("//div[@itemprop = 'reviewBody']")
        if reviewer && opinion && review_text
          reviews << {
            reviewer: reviewer.text,
            opinion: opinion.text,
            review_text: review_text.text.strip
          }
          review_counter += 1
          break if review_counter > 4
        end
      end
    end
  end

  def self.scrape_from_barnes_and_noble_link(link)
    doc = Nokogiri::HTML(open(link))
    isbn = doc.at("tr:contains('ISBN-13')").at('td').text
    scrape_goodreads_isbn(isbn)
  end

  def self.scrape_from_publishers_weekly(isbn)
    scrape_goodreads_isbn(isbn)
  end

  private

  def self.scrape_goodreads_recommendations(doc)
    RecommendedReading::List.new("Recommendations").tap do |list|
      doc.css("li.cover a").each do |recommendation|
        list.books << {
          title: recommendation.at("img")["alt"],
          link: recommendation['href']
        }
      end
    end
  end

end
