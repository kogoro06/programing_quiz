require "csv"

puts "\n=== Creating Quizzes ==="
CSV.foreach("db/csv/Separated_Quizzes.csv", headers: true) do |row|
  quiz = Quiz.create!(title: row["quiz_title"]) do |q|
    q.author_user_id = row["author_user_id"]
    q.title = row["quiz_title"]
    q.questions_count = 1
    q.questions.build(
      question: row["question"],
      correct_answer: row["correct_answer"],
      answer_source: row["answer_source"],
      explanation: row["explanation"]
    )
    p q.questions
    q.save(validate: false)
  end
  print "."
end