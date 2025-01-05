require "csv"

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
# emailでユーザーを検索し、存在しない場合は新しく作成
users.each do |user_attribute|
  user = User.find_or_create_by!(email: user_attribute[:email]) do |u|
    u.email    = user_attribute[:email]
    u.name     = user_attribute[:name]
    u.password = user_attribute[:password]
    u.role     = user_attribute[:role]
  end

  # ユーザーがDBにあればユーザー名を出す
  puts "作成済みユーザー：#{user.name}" if user.persisted?
end

# Profilesのダミーデータ作成


# Quizzesのダミーデータ生成
CSV.foreach('db/csv/dummy_quizzes.csv', headers: true) do |row|
  Quiz.find_or_create_by!(author_user_id: row['author_user_id'], title: row['title']) do |quiz|
    quiz.author_user_id = row['author_user_id']
    quiz.title = row['title']
  end
end

# Questionsのダミーデータ生成
CSV.foreach('db/csv/dummy_questions_and_choices.csv', headers: true) do |row|
  Question.find_or_create_by!(quiz_id: row['quiz_id'], question: row['question']) do |question|
    question.quiz_id = row['quiz_id']
    question.question = row['question']
    question.correct_answer = row['correct_answer']
    question.answer_source = row['answer_source']
    question.explanation = row['explanation']
  end
end

# Choicesのダミーデータ作成
CSV.foreach('db/csv/dummy_questions_and_choices.csv', headers: true) do |row|
  Choice.find_or_create_by!(question_id: row['question_id'], choice1: row['choice1'], choice2: row['choice2'], choice3: row['choice3'], choice4: row['choice4']) do |choice|
    choice.question_id = row['question_id']
    choice.choice1 = row['choice1']
    choice.choice2 = row['choice2']
    choice.choice3 = row['choice3']
    choice.choice4 = row['choice4']
  end
end
