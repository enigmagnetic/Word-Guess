#Game Dictionary
easy_words = ["pipes", "carets", "apple", "orange", "book", "computer"]
med_words = ["esoteric", "consciousness", "illuminate", "discrepancy", "galactic"]
hard_words = ["the meaning of life", "vibrational entity", "we are made of star stuff"]

class Display
  attr_accessor :display_word, :user_guess, :counter_finish, :counter_orb, :counter_base

  def initialize(game_instance)
    @winning_word = game_instance.winning_word
    @user_guess = nil
    @display_word = ""
    @selected_level = game_instance.selected_level
    # set initial word display
    @winning_word.each_char do |char|
      if char == " "
        @display_word += "  "
      else
        @display_word += "_ "
      end
    end

    @counter_finish = " " * (@selected_level - 1) + "|"
    @counter_orb = "o"
    @counter_base = "=" * @selected_level
  end

  def update_display
    char_positions =[]
    i = -1
    # push guessed character index to an array
    @winning_word.each_char do |char|
      i += 1
      if char == @user_guess
        # times 2 to adjust for blanks in display_word
        char_positions.push(i * 2)
      end
    end
    # replace _ at those indices with the guessed character
    char_positions.each do |pos|
      @display_word[pos] = @user_guess
    end
  end

  def display_counter #race progession
    <<-COUNTER
    #{@counter_finish}
    #{@counter_orb}
    #{@counter_base}
    COUNTER
  end

  def update_counter
    @counter_orb.prepend(" ")
  end

end # End of Display definition

class Guess
  attr_accessor :guess

  def initialize(input)
    @guess = input
  end

  def valid?
    /[a-z]+[[:blank]]*\b/.match(@guess) ? true : false
  end

  def correct?(word)
    @guess.length == 1 && word.include?(@guess) ? true : false
  end

  def end_game?

  end
end # End of Guess class

class Game
  attr_reader :level, :winning_word, :selected_level

  attr_accessor :user_guess, :interface

  def initialize
    # gets difficulty level from the user
    puts "Welcome.."
    print "Choose a level (easy, medium, hard)"
    @level = gets.chomp.strip.downcase

    until @level == "easy" || @level == "medium" || @level == "hard"
      print "Please select a valid level (easy, medium, hard): "
      @level = gets.chomp.strip.downcase
    end

    # choose a random sample from the selected level array
    case @level
    when "easy"
      @winning_word = easy_words.sample
      @selected_level = 12
    when "medium"
      @winning_word = med_words.sample
      @selected_level = 10
    when "hard"
      @winning_word = hard_words.sample
      @selected_level = 10
    end
    # create a new Display for this game, pass the Game instance to it
    @interface = Display.new(self)
    @used_letters = []
  end #End of Game initialization method

  #Validate User input
  puts @interface.display_counter
  puts "Phrase: " + @interface.display_word
  # puts "Incorrect guesses: #{@used_letters.join(", ")}"
  puts "Please enter a letter to guess:"
  @user_guess = Guess.new(gets.chomp.strip.downcase)

  until @user_guess.valid?
     puts "Please enter alpha characters only:"
     @user_guess = Guess.new(gets.chomp.strip.downcase)
  end

  @interface.user_guess = @user_guess

  if @user_guess == @winning_word
    @interface.display_word.gsub!("_", "-")
    end_game
  elsif @used_letters.include?(@user_guess)
    puts "You already tried #{@user_guess}. Try again"
    end_game
  elsif @user_guess.correct?(@winning_word)
    @interface.update_display
  else
    puts "Nope!"
    @used_letters << @user_guess
    @interface.update_counter
    end_game
  end


  def end_game
    # declares a win when all blanks have been replaced in display_word
    if !(@interface.display_word.include?("_"))
      puts "You got it!"
    elsif
      if @interface.counter_orb.length >= @interface.counter_finish.length
        puts "You are trapped on this plane of entanglement."
        #display something dramatic
        exit #TODO TBD
      elsif @interface.counter_orb.length == @interface.counter_finish.length
        puts "EEKS! Last guess!"
        #display maybe some flashing...
      end
    else
      accept_guess
    end
  end

  #Decide win or Lose
end # End of Game class definition
