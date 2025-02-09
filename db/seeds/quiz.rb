require "csv"

puts "\n=== Creating Quizzes ==="
CSV.foreach("db/csv/Separated_Quizzes.csv", headers: true) do |row|
  quiz = Quiz.find_or_create_by!(title: row["quiz_title"]) do |q|
    q.author_user_id = row["author_user_id"]
    q.title = row["quiz_title"]
    q.questions_count = 0
    print "."
    q.questions.build(
      question: row["question"],
      correct_answer: row["correct_answer"],
      answer_source: row["answer_source"],
      explanation: row["explanation"]
    )
    q.questions.each do |question|
      question.choices.build(
        choice1: row["choice1"],
        choice2: row["choice2"],
        choice3: row["choice3"],
        choice4: row["choice4"]
      )
    end
    q.tag_quizzes.build(
      tag_id: row["tag_id"]
    )
    q.save(validate: false)
  end
end