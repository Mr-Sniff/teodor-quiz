require 'sqlite3'
require_relative 'main'


class Question
  attr_reader :prompt, :answer


  def initialize(prompt, answer)
    @prompt = prompt
    @answer = answer
    raise ArgumentError, "prompt must not be empty" if @prompt.empty?
  end

  def ask
    puts prompt
    gets.chomp
  end

  def correct?(reply)
    reply.strip.downcase == answer.downcase
  end

  def to_s
    "#{prompt} (#{answer})"
  end

  def hint
    p "Hint, first letter: " + answer[0]
    answer[0]
  end
end

class MultipleChoice < Question

  def initialize(prompt, answer, alternatives)
    super(prompt, answer)
    @alternatives = alternatives
    @answer = answer
  end

  def ask
    puts prompt
    @alternatives.each_with_index do |alternative, i| 
      p (i+1).to_s + ": " + alternative
    end
    gets.chomp
  end

  def correct?(reply)
    super || (@alternatives.index(@answer)+1).to_s == reply
  end
end

class SelfGraded < Question
  def correct?(reply)
    p "Svaret var: " + @answer
    p "Skulle du säga att det var korrekt? (Y/N)"
    gets.chomp.downcase == "y"
  end
end
