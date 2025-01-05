class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile

  enum role: { general: 0, admin: 1 } # 役割の定義

  has_many :quizzes
  has_many :questions, through: :quizzes

  validates :name, presence: true, length: { in: 1..20 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
end
