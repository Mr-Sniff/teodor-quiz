class Question
  def initialize(prompt, answer)
    @prompt = prompt
    @answer = answer
  end

  def prompt
    @prompt
  end

  def answer
    @answer
  end

  def answer=(new_answer)
    @answer = new_answer
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
end
