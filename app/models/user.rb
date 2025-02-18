class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  has_one :profile, dependent: :destroy

  enum role: { general: 0, admin: 1 }

  has_many :quizzes
  has_many :questions, through: :quizzes

  validates :name, presence: true, length: { in: 1..20 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :uid, uniqueness: { scope: :provider }, allow_nil: true

  # OAuthログイン用メソッド
  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first_or_initialize

    user.name = auth.info.name if user.name.blank?

    if user.new_record?
      user.password = Devise.friendly_token[0, 20]
    end

    is_new_user = user.new_record?

    user.save!

    user.create_profile if user.profile.nil?

    return user, is_new_user
  end
end
