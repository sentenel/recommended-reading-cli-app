require 'pry'

class RecommendedReading::CLI

  LISTS = ["Amazon Bestsellers", "New York Times Bestsellers", "Barnes and Noble Bestsellers"]

  def call
    while true
      puts "Please enter the number of the booklist you would like to view"
      LISTS.each.with_index {|list, index| puts "#{index + 1}. #{list}"}

      input = gets.strip

      break if ["Q", "QUIT", "EXIT"].include?(input.upcase)

      case input.to_i
      when 1
        puts LISTS[0]
      when 2
        puts LISTS[1]
      when 3
        puts LISTS[2]
      else
        puts "I did not understand."
      end
    end
  end

end
