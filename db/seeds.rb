require "csv"

# バリデーションを一時的に無効化
[ Quiz, Question, Choice, Tag, TagQuiz ].each do |model|
  model.class_eval do
    # バリデーションを一時的に無効化
    _validate_callbacks.clear
    # 外部キー制約も一時的に無効化
    if respond_to?(:belongs_to_required_by_default)
      self.belongs_to_required_by_default = false
    end
  end
end

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

  # ユーザーがテーブルにあればユーザー名を出す
  puts "作成済みユーザー：#{user.name}" if user.persisted?
end

# Profilesのダミーデータ作成
profiles.each do |profile_attribute|
  profile = Profile.find_or_create_by!(user_id: profile_attribute[:user_id]) do |prof|
    prof.bio                = profile_attribute[:bio]
    prof.studying_languages = profile_attribute[:studying_languages]
    prof.github_link        = profile_attribute[:github_link]
    prof.x_link             = profile_attribute[:x_link]
    prof.user_id            = profile_attribute[:user_id]
  end
end

# Quizzesのダミーデータ生成
quiz_data = {}
CSV.foreach('db/csv/dummy_quizzes.csv', headers: true) do |row|
  quiz_data[row['quiz_id'].to_i] = {
    title: row['title'],
    author_user_id: row['author_user_id'],
    questions_count: row['questions_count']
  }
end

# Questionsのダミーデータ生成
questions_data = []
CSV.foreach('db/csv/dummy_questions_and_choices.csv', headers: true) do |row|
  questions_data << {
    quiz_id: row['quiz_id'].to_i,
    question: row['question'],
    correct_answer: row['correct_answer'],
    answer_source: row['answer_source'],
    explanation: row['explanation']
  }
end

# Choicesのダミーデータ作成
choices_data = []
CSV.foreach('db/csv/dummy_questions_and_choices.csv', headers: true) do |row|
  choices_data << {
    question_id: row['question_id'].to_i,
    choice1: row['choice1'],
    choice2: row['choice2'],
    choice3: row['choice3'],
    choice4: row['choice4']
  }
end

# Tagsのダミーデータ作成
CSV.foreach('db/csv/tags.csv', headers: true) do |row|
  Tag.create!(
    name: row['name'],
    color: row['color']
  )
end

# TagQuizzesのダミーデータ作成
CSV.foreach('db/csv/tag_quizzes.csv', headers: true) do |row|
  TagQuiz.create!(
    tag_id: row['tag_id'].to_i,
    quiz_id: row['quiz_id'].to_i
  )
end

# バリデーションを元に戻す
[ Quiz, Question, Choice, Tag, TagQuiz ].each do |model|
  model.reset_callbacks(:validate)
end
