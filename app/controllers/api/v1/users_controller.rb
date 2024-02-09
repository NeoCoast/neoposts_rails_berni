# frozen_string_literal: true

# :reek:UncommunicativeModuleName
module Api
  module V1
    # class Api::V1::UsersController
    class UsersController < ApplicationController
      def index
        @users = User.all
      end
    end
  end
end
