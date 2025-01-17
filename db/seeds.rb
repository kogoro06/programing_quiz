require "csv"

puts "\n=== Creating Users ==="
users = [
  # 管理者１
  {
    email: Rails.application.credentials.admin_email1,
    password: Rails.application.credentials.admin_password1,
    name: "admin_user1",
    role: "admin"
  },

  # 管理者２
  {
    email: Rails.application.credentials.admin_email2,
    password: Rails.application.credentials.admin_password2,
    name: "admin_user2",
    role: "admin"
  },

  # 一般ユーザー１
  {
    email: "user1@example.com",
    password: "password",
    name: "user1",
    role: "general"
  },

  # 一般ユーザー２
  {
    email: "user2@example.com",
    password: "password",
    name: "user2",
    role: "general"
  }
]

# emailでユーザーを検索し、存在しない場合は新しく作成
users.each do |user_attribute|
  user = User.find_or_create_by!(email: user_attribute[:email]) do |u|
    u.email    = user_attribute[:email]
    u.name     = user_attribute[:name]
    u.password = user_attribute[:password]
    u.role     = user_attribute[:role]
  end
  puts "作成済みユーザー：#{user.name}" if user.persisted?
end

puts "\n=== Creating Profiles ==="
profiles = [
  # 管理者ユーザー１
  {
    bio: "管理者ユーザー１の自己紹介",
    studying_languages: "html css javascript ruby",
    github_link: "https://github.com/",
    x_link: "https://x.com/home",
    user_id: 1
  },

  # 管理者ユーザー２
  {
    bio: "管理者ユーザー２の自己紹介",
    studying_languages: "html css javascript ruby",
    github_link: "https://github.com/",
    x_link: "https://x.com/home",
    user_id: 2
  },

  # 一般ユーザー１
  {
    bio: "一般ユーザー１の自己紹介",
    studying_languages: "html css javascript ruby",
    github_link: "https://github.com/",
    x_link: "https://x.com/home",
    user_id: 3
  },

  # 一般ユーザー２
  {
    bio: "一般ユーザー２の自己紹介",
    studying_languages: "html css javascript ruby",
    github_link: "https://github.com/",
    x_link: "https://x.com/home",
    user_id: 4
  }
]

profiles.each do |profile_attribute|
  Profile.find_or_create_by!(user_id: profile_attribute[:user_id]) do |prof|
    prof.bio                = profile_attribute[:bio]
    prof.studying_languages = profile_attribute[:studying_languages]
    prof.github_link        = profile_attribute[:github_link]
    prof.x_link            = profile_attribute[:x_link]
    prof.user_id           = profile_attribute[:user_id]
  end
  print "."
end

puts "\n=== Creating Quiz Data ==="
# Quizzesのダミーデータ生成
puts "\nCreating Quizzes..."
CSV.foreach('db/csv/dummy_quizzes.csv', headers: true) do |row|
  Quiz.find_or_create_by(id: row['quiz_id']) do |q|
    q.author_user_id = row['author_user_id']
    q.title = row['title']
    q.questions_count = row['questions_count']
    q.save(validate: false)
  end
  print "."
end

# Questions と Choices のダミーデータ生成
puts "\nCreating Questions and Choices..."
CSV.foreach('db/csv/dummy_questions_and_choices.csv', headers: true) do |row|
  question = Question.find_or_create_by(id: row['question_id']) do |q|
    q.quiz_id = row['quiz_id']
    q.question = row['question']
    q.correct_answer = row['correct_answer']
    q.answer_source = row['answer_source']
    q.explanation = row['explanation']
    q.save(validate: false)
  end

  Choice.find_or_create_by(question_id: question.id) do |c|
    c.choice1 = row['choice1']
    c.choice2 = row['choice2']
    c.choice3 = row['choice3']
    c.choice4 = row['choice4']
    c.save(validate: false)
  end
  print "."
end

# Tagsのダミーデータ作成
puts "\nCreating Tags..."
tag_data = {}
CSV.foreach('db/csv/tags.csv', headers: true) do |row|
  tag = Tag.find_or_create_by!(id: row['tag_id']) do |t|
    t.name = row['name']
    t.color = row['color']
  end
  tag_data[row['name']] = tag
  print "."
end

# TagQuizzesのダミーデータ作成
puts "\nCreating TagQuizzes..."
CSV.foreach('db/csv/tag_quizzes.csv', headers: true) do |row|
  TagQuiz.find_or_create_by!(quiz_id: row['quiz_id'], tag_id: row['tag_id'])
  print "."
end

puts "\nSeeding completed! 🎉"
