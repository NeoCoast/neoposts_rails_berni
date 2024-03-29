# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  let(:user) { create :user }
  let(:create_user) { create_list(:user, 15) }
  let!(:auth_headers) { user.create_new_auth_token }

  describe 'GET users #index' do
    before(:each) do
      create_user
      get api_v1_users_path, headers: auth_headers, as: :json
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'JSON body response contains expected users attributes' do
      json_response = JSON.parse(response.body)
      json_response['users'].each do |json|
        expect(json.keys).to match_array(%w[id email nickname first_name last_name birthday])
      end
    end

    it 'JSON body response has 16 users' do
      json_response = JSON.parse(response.body)
      expect(json_response['users'].length).to eq(16)
    end

    it "JSON body response has 16 users' nickname" do
      json_response = JSON.parse(response.body)
      users = User.all
      users.each { |user| expect(json_response['users'].map { |x| x['nickname'] }).to include(user.nickname) }
    end
  end

  describe 'PUT users #update' do
    before(:each) do
      put api_v1_user_path(user), headers: auth_headers, params: { user: updated_attributes }, as: :json
    end

    context 'with valid attributes' do
      let(:updated_attributes) { { first_name: 'UpdatedFirstName', last_name: 'UpdatedLastName' } }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'updates the user attributes' do
        user.reload
        expect(user.first_name).to eq(updated_attributes[:first_name])
        expect(user.last_name).to eq(updated_attributes[:last_name])
      end
    end

    context 'with invalid attributes' do
      let!(:another_user) { create :user }
      let(:updated_attributes) { { email: another_user.email, nickname: another_user.nickname } }

      it 'validates email and nickname uniqueness' do
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)

        expect(json_response['errors']).to include('Nickname has already been taken')
        expect(json_response['errors']).to include('Email has already been taken')
      end
    end
  end

  describe 'Follow User' do
    let(:user1) { create :user }

    context 'with not found user' do
      before(:each) do
        post follow_api_v1_user_path(-1), headers: auth_headers
      end

      it 'doest not found user' do
        expect(response).to have_http_status(404)
      end
    end

    context 'with authenticated user' do
      before(:each) do
        post follow_api_v1_user_path(user1), headers: auth_headers
      end

      it 'creates relationship with follower user' do
        expect(Relationship.last.follower).to eq(user)
      end

      it 'creates relationship with followed user1' do
        expect(Relationship.last.followed).to eq(user1)
      end
    end
  end

  describe 'Unfollow User' do
    let(:user1) { create :user }
    let(:follow) { post follow_api_v1_user_path(user1.id), headers: auth_headers }

    context 'with authenticated user' do
      before(:each) do
        follow
        post unfollow_api_v1_user_path(user1.id), headers: auth_headers
      end

      it 'eliminates the only one relationship' do
        expect(Relationship.any?).to eq(false)
      end
    end

    context 'with not found user' do
      before(:each) do
        post unfollow_api_v1_user_path(-1), headers: auth_headers
      end

      it 'doest not found user' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
