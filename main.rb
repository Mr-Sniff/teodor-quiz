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




# questions = [
#   MultipleChoice.new("Vad är huvudstaden i Sverige?", "Stockholm", ["Oslo", "Stockholm", "Köpenhamn"]),
#   Question.new("Vad heter huvudstaden i Norge?", "Oslo"),
#   Question.new("Vilket år släpptes Ruby 1.0?", "1996"),
#   Question.new("Vad svarar 5.class?", "Integer"),
# ]
#
# score = 0
#
# questions.each do |q|
#   reply = q.ask
#   if q.correct?(reply)
#     puts "Rätt!"
#     score += 1
#   else
#     puts "Fel. Rätt svar: #{q.answer}"
#   end
# end
#
# puts "#{score} av #{questions.length} rätt."



