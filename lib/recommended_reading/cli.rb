class RecommendedReading::CLI

  LISTS = ["Amazon Bestsellers", "New York Times Bestsellers", "Barnes and Noble Bestsellers"]

  def call
    testbook = RecommendedReading::Book.new('006242713X')
    testbook.title = "The Plant Paradox"
    testbook.author = "Steven R. Gundry"
    testbook.ratings = [[3.84, 1]]
    testbook.genres = ["Health", "Nonfiction", "Food and Drink > Food", "Science", "Health > Nutrition", "Self Help"]
    testbook.summary = 'From renowned cardiac surgeon Steven R. Gundry, MD, a revolutionary look at the hidden compounds in "healthy" foods like fruit, vegetables, and whole grains that are causing us to gain weight and develop chronic disease.'
    testbook.reviews = [[1, "To put it generously, I am not the intended audience for a book like this, and I would not normally seek out, let alone read, a diet book. Nonetheless..."]]
    testbook.quotes = ["The most dangerous trick pulled by lectins, which I now see on a daily basis in my patients, is that they bear an uncanny similarity to the proteins on many of our important organs, nerves, and joints."]

    puts "Please enter the number of the booklist you would like to view"
    LISTS.each.with_index {|list, index| puts "#{index + 1}. #{list}"}

    input = gets.strip

    unless ["Q", "QUIT", "EXIT"].include?(input.upcase)
      case input.to_i
      when 1
        display_list [testbook]
      when 2
        display_list ["The President is Missing"]
      when 3
        display_list ["Clock Dance"]
      else
        puts "I did not understand."
        call
      end
    end
  end

  def display_list(booklist)
    puts "Enter a book number for details or 'back' to select another list:"
    booklist.each.with_index {|book, index| puts "#{index + 1}. #{book.title}"}
    input = gets.strip

    if input == 'back'
      call
    elsif (1..booklist.length).include?(input.to_i)
      book_details booklist[input.to_i-1]
    else
      puts "I did not understand."
      display_list(booklist)
    end
  end

  def book_details(book)
    puts "#{book.title} by #{book.author}"
    puts "Average rating: #{book.average_rating}"
    puts "Genres: #{book.genres}"
    puts ""
    puts book.summary

    input = nil
    while input != 5
      puts ""
      puts "What would you like to see?"
      puts "1. Reviews"
      puts "2. Quotes"
      puts "3. Recommendations based on this book"
      puts "4. Rating information"
      puts "5. View another list"

      input = gets.strip.to_i

      case input
      when 1
        puts "#{book.reviews[0][0]} stars"
        puts book.reviews[0][1]
      when 2
        puts book.quotes[0]
      when 3
        puts "Recommendation stub"
      when 4
        puts "Rating information stub"
      when 5
        break
      else
        puts "I did not understand."
      end
    end
    call
  end
end
