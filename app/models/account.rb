class Account < ApplicationRecord
    has_many :items, dependent: :destroy
    belongs_to :user
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :account_email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
    validates :account_password, presence: true, length: { in: 1..32 }
end
