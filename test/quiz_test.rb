require_relative '../question'

def test_quiz
  db = SQLite3::Database.new("quiz.db")
  db.results_as_hash = true

  rows = db.execute("SELECT prompt, answer FROM questions")
  multiple_rows = db.execute("SELECT prompt, answer, q_id FROM multiple_choice_questions")
  self_graded_rows = db.execute("SELECT prompt, answer FROM self_graded_questions")
  

  questions = rows.map do |row|
    Question.new(row["prompt"], row["answer"])
  end

  multiple_choice_questions = multiple_rows.map do |row|
    alternatives = db.execute(
      "SELECT answer FROM multiple_choice_answers WHERE q_id = ?", [row["q_id"]]).map { |r| r["answer"] }

    MultipleChoice.new(row["prompt"], row["answer"], alternatives)
  end


  self_graded_questions = self_graded_rows.map do |row|
    alternatives = db.execute(
      "SELECT answer FROM multiple_choice_answers WHERE q_id = ?", [row["q_id"]]).map { |r| r["answer"] }

    SelfGraded.new(row["prompt"], row["answer"])
  end

  Quiz.new(questions + multiple_choice_questions + self_graded_questions).run
end

test_quiz
