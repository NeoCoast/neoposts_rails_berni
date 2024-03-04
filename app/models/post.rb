# frozen_string_literal: true

# class Post
class Post < ApplicationRecord
  belongs_to :user
  validates :title, :body, :published_at, presence: true

  before_validation :set_published_at, on: :create

  private

  def set_published_at
    self.published_at = DateTime.now
  end
end
