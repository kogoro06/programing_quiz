class Profile < ApplicationRecord
  has_one :user

  validates :bio, length: { maximum: 250 }
  validates :studying_languages, length: { maximum: 250 }
  validates :github_link, length: { maximum: 250 }
  validates :x_link, length: { maximum: 250 }
  validates :user_id, presence: true

  has_one_attached :user_icon
end
