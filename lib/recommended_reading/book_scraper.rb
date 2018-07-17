require 'pry'
class RecommendedReading::BookScraper

  def scrape_goodreads(isbn)
    doc = Nokogiri::HTML(open("https://www.goodreads.com/book/isbn/#{isbn}"))
    Hash.new.tap do |book|
      book[:title] = doc.css('h1.bookTitle').text.strip
      book[:authors] = doc.css('div#bookAuthors').text.gsub(/( by)*?/, '').strip.gsub(/by\n+/, '')
      book[:summary] = doc.css('div#description').text.gsub(/\.\.\.more/, '').strip
      book[:genres] = doc.css('div.left a.bookPageGenreLink').map {|element| element.text}
      ratings = doc.css('div#bookMeta script').first.children.first.content.scan(/\d+ ratings/)
      book[:ratings] =ratings.map {|total| total.gsub(/ ratings/, '').to_i}
    end
  end

  def scrape_goodreads_review(isbn)
    doc = Nokogiri::HTML(open("https://www.goodreads.com/book/isbn#{isbn}"))
    #review_url = 'https://www.goodreads.com' + doc.css('div#bookReviews div.left.bodycol a')[index]['href']
    #review = Nokogiri::HTML(open(rating_url))
    #reviewer: review.at("//a[@itemprop = 'author']").text
    #opinion: rating.css('span.staticStar').first.text
    #review_text: rating.at("//a[@itemprop = 'reviewBody']").text.strip
  end

end
