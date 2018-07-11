class RecommendedReading::CLI

  LISTS = ["Amazon Bestsellers", "New York Times Bestsellers", "Barnes and Noble Bestsellers"]

  def call
    puts "Please enter the number of the booklist you would like to view"
    LISTS.each.with_index {|list, index| puts "#{index + 1}. #{list}"}

    input = gets.strip

    unless ["Q", "QUIT", "EXIT"].include?(input.upcase)
      case input.to_i
      when 1
        display_list ["The Plant Paradox"]
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
    booklist.each.with_index {|list, index| puts "#{index + 1}. #{list}"}
    input = gets.strip

    if input == 'back'
      self.call
    elsif (1..booklist.length).include?(input.to_i)
      select_book booklist[input.to_i-1]
    else
      puts "I did not understand."
      display_list(booklist)
    end
  end

  def select_book(book)
  end

end
