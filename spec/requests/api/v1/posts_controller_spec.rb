# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  let(:user) { create :user }
  let(:followed_user) { create :user }
  let!(:create_posts) { create_list(:post, 11, user: followed_user) }
  let!(:auth_headers) { user.create_new_auth_token }
  let!(:attrs_post) { attributes_for :post }

  describe 'GET posts #index' do
    before(:each) do
      user.follow(followed_user)
      get api_v1_posts_path(user), headers: auth_headers, as: :json
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'JSON body response contains expected posts attributes' do
      json_response = JSON.parse(response.body)
      json_response['posts'].each do |json|
        expect(json.keys).to match_array(%w[id title body published_at user_id])
      end
    end

    it 'JSON body response has 5 posts' do
      json_response = JSON.parse(response.body)
      expect(json_response['posts'].length).to eq(10)
    end

    it 'JSON body returns posts ordered by published_at in descending order by default' do
      json_response = JSON.parse(response.body)
      published_at_values = json_response['posts'].map { |post| post['published_at'] }

      expect(published_at_values).to eq(published_at_values.sort.reverse)
    end

    it 'JSON body returns returns posts ordered by published_at in ascending order when specified' do
      get api_v1_posts_path(order: 'ASC'), headers: auth_headers, as: :json
      json_response = JSON.parse(response.body)
      published_at_values = json_response['posts'].map { |post| post['published_at'] }

      expect(published_at_values).to eq(published_at_values.sort)
    end

    it 'JSON body returns posts that match the search query in title, body, or user attributes' do
      get api_v1_posts_path(search: followed_user.first_name), headers: auth_headers, as: :json

      json_response = JSON.parse(response.body)
      expect(json_response['posts'].length).to eq(10)
    end

    it 'JSON body paginates correctly' do
      get api_v1_posts_path(page: 2), headers: auth_headers, as: :json

      json_response = JSON.parse(response.body)
      expect(json_response['posts'].length).to eq(1)
    end
  end

  describe 'GET posts #show' do
    let!(:post) { create :post, user: user }

    before(:each) do
      get api_v1_post_path(post), headers: auth_headers, as: :json
    end

    it 'JSON body response contains expected post attributes' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[id title body published_at user_id])
    end

    it "JSON body response has post's title" do
      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq(post.title)
    end
  end

  describe 'GET posts #show with invalid post_id' do
    before(:each) do
      get api_v1_post_path(id: -1), headers: auth_headers, as: :json
    end

    it 'renders json error message' do
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('Post not found!')
    end
  end

  describe 'POST create a post' do
    before(:each) do
      post api_v1_posts_path(user), headers: auth_headers, params: attrs_post, as: :json
    end

    it 'JSON body response contains expected post attributes' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to match_array(%w[id title body published_at user_id])
    end
  end
end
