# frozen_string_literal: true

# class Post
class Post < ApplicationRecord
  belongs_to :user
  validates :title, :body, :published_at, presence: true

  before_validation :set_published_at, on: :create

  scope :scope_order, lambda { |order|
    return unless order.casecmp?('ASC') || order.casecmp?('DESC')

    order(published_at: order)
  }
  scope :scope_search, lambda { |search|
    return unless search.present?

    joins(:user).where(
      'title ILIKE :search or body ILIKE :search or users.nickname ILIKE :search OR users.first_name ILIKE :search',
      search: "%#{search}%"
    )
  }

  private

  def set_published_at
    self.published_at = DateTime.now
  end
end
