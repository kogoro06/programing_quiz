class Contact < ApplicationRecord
  validates :email, presence: true
  validates :name, presence: true, length: {maximum: 100}
  validates :title, presence: true, length: {maximum: 100}
  validates :text, presence: true, length: {maximum: 2000}

end
