require 'sqlite3'
 
db = SQLite3::Database.new('quiz.db')
 
db.execute('DROP TABLE IF EXISTS questions')
db.execute('DROP TABLE IF EXISTS multiple_choice_questions')
db.execute('DROP TABLE IF EXISTS multiple_choice_answers')
 
db.execute <<-SQL
  CREATE TABLE questions (
    prompt TEXT NOT NULL,
    answer TEXT NOT NULL
  );
SQL

db.execute <<-SQL
  CREATE TABLE multiple_choice_questions (
    prompt TEXT NOT NULL,
    answer TEXT NOT NULL,
    q_id TEXT NOT NULL
  );
SQL


db.execute <<-SQL
  CREATE TABLE multiple_choice_answers (
    q_id TEXT NOT NULL,
    answer TEXT NOT NULL
  );
SQL
 
rows = [
  ["Vad är huvudstaden i Sverige?", "Stockholm"],
  ["Hur många ben har en spindel?", "8"],
  ["Vilket år släpptes Ruby första gången?", "1995"]
]
 
rows.each do |prompt, answer|
  db.execute("INSERT INTO questions (prompt, answer) VALUES (?, ?)", [prompt, answer])
end
 
multiple_rows = [
  ["Vad är huvudstaden i Sverige?", "Stockholm", 1],
  ["Vad är mitt efternamn", "Boestad", 2],
]
 
multiple_rows.each do |prompt, answer, q_id|
  db.execute("INSERT INTO multiple_choice_questions (prompt, answer, q_id) VALUES (?, ?, ?)", [prompt, answer, q_id])
end

answer_rows = [
  [1, "Stockholm"],
  [1, "Oslo"],
  [1, "Köpenhamn"],
  [2, "Boestad"],
  [2, "Andersson"]
]

answer_rows.each do  |q_id, answer|  
  db.execute("INSERT INTO multiple_choice_answers (q_id, answer) VALUES (?, ?)", [q_id, answer])
end

