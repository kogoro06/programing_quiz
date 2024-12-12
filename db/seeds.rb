users = [
  # 管理者１
  {
  email: "admin_user1@example.com",
  password: "admin_password",
  name: "admin_user1",
  role: "admin"
  },

  # 管理者２
  {
    email: "admin_user2@example.com",
    password: "admin_password",
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

  # ユーザーがDBにあればユーザー名を出す
  puts "作成済みユーザー：#{user.name}" if user.persisted?
end