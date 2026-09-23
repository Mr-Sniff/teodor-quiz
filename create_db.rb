require 'sqlite3'
 
db = SQLite3::Database.new('quiz.db')
 
db.execute('DROP TABLE IF EXISTS questions')
 
db.execute <<-SQL
  CREATE TABLE questions (
    prompt TEXT NOT NULL,
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
 
