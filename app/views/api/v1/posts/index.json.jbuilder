# frozen_string_literal: true

json.posts do
  json.array! @posts do |post|
    json.partial! 'post', post: post
  end
end
