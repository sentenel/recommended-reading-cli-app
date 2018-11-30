class RecommendedReading::CLI

  LISTS = ["New York Times Bestsellers", "Barnes and Noble Bestsellers", "Publishers Weekly"]

  def call
    LISTS.each.with_index {|list, index| puts "#{index + 1}. #{list}"}
    puts "#{LISTS.length + 1}. Quit"
    puts "Please enter the number of the booklist you would like to view, or #{LISTS.length + 1} to quit."
    input = gets.strip
    puts ""

    case input.to_i
    when 1
      display_list RecommendedReading::List.new_from_nyt
    when 2
      display_list RecommendedReading::List.new_from_barnes_and_noble
    when 3
      display_list RecommendedReading::List.new_from_publishers_weekly
    when LISTS.length + 1
      puts "Thank you for using Recommended Reading!"
      exit
    else
      puts "I did not understand."
      call
    end
  end

  def display_list(booklist)

    booklist.books.each.with_index {|book, index| puts "#{index + 1}. #{book[:title]}"}
    puts ""
    puts "Enter a book number for details or 'back' to select another list:"
    input = gets.strip


    if input == 'back'
      call
    elsif (1..booklist.books.length).include?(input.to_i)
      book_details booklist.get_book(input.to_i-1)
    else
      puts "I did not understand."
      display_list(booklist)
    end
  end

  def book_details(book)
    unless book.title
      puts "Book not found. Please make a new selection."
      puts ""
      call
    end

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
      puts "6. Quit"

      input = gets.strip.to_i
      puts ""

      case input
      when 1
        puts book.summary
      when 2
        display_total_ratings(book)
        puts "Average rating: #{book.average_rating}"
      when 3
        display_reviews(book)
      when 4
        display_recommendations(book)
      when 5
      when 6
        exit
      else
        puts "I did not understand."
      end
    end
    call
  end

  def display_reviews(book)
    puts "No reviews available." if book.reviews.length == 0
    book.reviews.each do |review|
      puts "#{review[:reviewer]}: #{review[:opinion]}"
      puts ""
      puts review[:review_text]
      puts ""

      if review == book.reviews[-1]
        puts "No further reviews."
        break
      end

      input = nil
      until [1, 2].include?(input)
        puts "What would you like to do?"
        puts "1. Next Review"
        puts "2. Return to book"

        input = gets.strip.to_i
        puts ""
        puts "I did not understand." unless [1, 2].include?(input)
      end
      break if input == 2
    end
  end

  def display_recommendations(book)
    recommendations = book.recommendations
    if recommendations.books.empty?
      puts "No recommendations available."
      puts ""
      book_details(book)
    end

    puts "Please enter a book number for details or 'back' to return."
    puts ""
    recommendations.books.each_with_index {|recommendation, index| puts "#{index + 1}. #{recommendation[:title]}"}

    input = gets.strip
    if input == 'back'
      book_details(book)
    elsif (1..recommendations.books.length).include?(input.to_i)
      book_details recommendations.get_book(input.to_i - 1)
    else
      puts "I did not understand."
      display_recommendations(book)
    end
  end

  def display_total_ratings(book)
    book.ratings.each_with_index {|number, index| puts "#{5-index} star ratings: #{number}"}
    puts "Total ratings: #{book.ratings.reduce(:+)}"
  end
end
