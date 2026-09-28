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
        puts "Rätt svar!"
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
  end

  def ask
    puts prompt
    @alternatives.each_with_index do |alternative, i| 
      p (i+1).to_s + ": " + alternative
    end
    gets.chomp
  end
end

def start
  db = SQLite3::Database.new("quiz.db")
  db.results_as_hash = true

  rows = db.execute("SELECT prompt, answer FROM questions")
  multiple_rows = db.execute("SELECT prompt, answer, q_id FROM multiple_choice_questions")
  

  questions = rows.map do |row|
    Question.new(row["prompt"], row["answer"])
  end

  multiple_choice_questions = multiple_rows.map do |row|
    alternatives = db.execute(
      "SELECT answer FROM multiple_choice_answers WHERE q_id = ?",
      [row["q_id"]]
    ).map { |r| r["answer"] }

    MultipleChoice.new(row["prompt"], row["answer"], alternatives)
  end

  Quiz.new(questions + multiple_choice_questions).run
end

start
