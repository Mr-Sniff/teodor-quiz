require 'sqlite3'

class Quiz
  attr_reader :questions

  def initialize(questions)
    @questions = questions
    raise ArgumentError, "questions must be array" if questions.class != Array

  end

  def run
    questions.each do |q| 
      reply = q.ask
      if q.correct?(reply)
        puts "rätt"
      else
        puts "fel :("
      end
    end
  end

end 


class Question
  attr_reader :prompt, :answer


  def initialize(prompt, answer)
    @prompt = prompt
    @answer = answer
    raise ArgumentError, "prompt must not be empty" if @prompt.empty?
  end

  def ask
    puts prompt
    # hint
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
  def ask
    alternatives = ["stockholm", "copenhagen", "gothenburg"]
    #TODO: lägg till i databasen, varje fråga borde ha svar, inte generiska.
    i = 0
    alternatives.each do |a| 
      i += 1
      p i.to_s + ": " + a 
    end
    super
  end
end

def start
  db = SQLite3::Database.new("quiz.db")
  db.results_as_hash = true

  rows = db.execute("SELECT prompt, answer FROM questions")

  questions = rows.map do |row|
    MultipleChoice.new(row["prompt"], row["answer"])
  end

  Quiz.new(questions).run
end

start
