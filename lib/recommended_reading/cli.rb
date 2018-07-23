require 'pry'
class RecommendedReading::CLI

  LISTS = ["Amazon Bestsellers", "New York Times Bestsellers", "Barnes and Noble Bestsellers", "Publishers Weekly"]

  def call
    puts "Please enter the number of the booklist you would like to view"
    LISTS.each.with_index {|list, index| puts "#{index + 1}. #{list}"}
    input = gets.strip
    puts ""

    unless ["Q", "QUIT", "EXIT"].include?(input.upcase)
      case input.to_i
      when 1
        display_list RecommendedReading::List.new_from_amazon
      when 2
        display_list RecommendedReading::List.new_from_nyt
      when 3
        display_list ["Clock Dance"]
      when 4
        display_list["stub"]
      else
        puts "I did not understand."
        call
      end
    end
  end

  def display_list(booklist)
    puts "Enter a book number for details or 'back' to select another list:"
    booklist.each.with_index {|book, index| puts "#{index + 1}. #{book[:title]}"}
    input = gets.strip
    puts ""

    if input == 'back'
      call
    elsif (1..booklist.length).include?(input.to_i)
      book_details booklist.get_book(input.to_i-1)
    else
      puts "I did not understand."
      display_list(booklist)
    end
  end

  def book_details(book)
    puts "#{book.title} by #{book.authors}"
    puts "Average rating: #{book.average_rating}"
    puts "Genres: #{book.genres}"

    input = nil
    while input != 5
      puts ""
      puts "What would you like to see?"
      puts "1. Summary"
      puts "2. Rating information"
      puts "3. Reviews"
      puts "4. Recommendations based on this book"
      puts "5. View another list"

      input = gets.strip.to_i
      puts ""

      case input
      when 1
        puts book.summary
      when 2
        book.display_total_ratings
        puts "Average rating: #{book.average_rating}"
      when 3
        display_reviews(book)
      when 4
        puts "Recommendation stub"
      when 5
        break
      else
        puts "I did not understand."
      end
    end
    call
  end

  def display_reviews(book)
    book.reviews.each do |review|
      puts "What would you like to do?"
      puts "1. Next Review"
      puts "2. Return to book"

      input = gets.strip.to_i
      puts ""

      case input
      when 1
        puts "#{review[:reviewer]}: #{review[:opinion]}"
        puts ""
        puts review[:review_text]
        puts ""
      when 2
        break
      end
    end
    puts "No further reviews."
  end

end