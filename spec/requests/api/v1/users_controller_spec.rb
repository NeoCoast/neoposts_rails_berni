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
end
