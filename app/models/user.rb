class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :password,
    format: { with: /\A(?=.*[[:digit:]]).*\z/, message: "must contain at least one digit" },
    allow_nil: true
  validates :password,
    format: { with: /\A(?=.*[!@#$%^&*()\-_=+\[\]{}|;:'\",.<>?\/\\]).*\z/, message: "must contain at least one special character" },
    allow_nil: true
  validates :password,
    format: { with: /[!@#$%^&*()\-_=+\[\]{}|;:'",.<>?\/\\]/, message: "must contain at least one special character" },
    allow_nil: true
end
