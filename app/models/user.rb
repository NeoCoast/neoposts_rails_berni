# frozen_string_literal: true

# class User
class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable
  include DeviseTokenAuth::Concerns::User

  validates :nickname, uniqueness: { case_sensitive: false }
  validates :first_name, :last_name, :nickname, :email, presence: true
end
