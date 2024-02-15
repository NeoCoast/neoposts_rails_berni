# frozen_string_literal: true

# :reek:UncommunicativeModuleName
module Api
  module V1
    # class Api::V1::UsersController
    class UsersController < ApplicationController
      before_action :find_user, only: [:update]

      def index
        @users = User.all
      end

      def update
        if password_present? && user_params[:password] == user_params[:password_confirmation]
          update_with_password
        elsif password_present?
          render_error("Password and password confirmation don't match")
        else
          return if @user.update(user_params.except(:current_password))

          render_error(@user.errors.full_messages)
        end
      end

      private

      def password_present?
        user_params[:password].present?
      end

      def find_user
        @user = User.find(params[:id])
      end

      def update_with_password
        return if @user.update_with_password(user_params)

        render_error(@user.errors.full_messages)
      end

      def render_error(errors)
        render json: { errors: errors }, status: :unprocessable_entity
      end

      def user_params
        params.require(:user).permit(:email, :nickname, :first_name, :last_name, :birthday, :password,
                                     :password_confirmation, :current_password)
      end
    end
  end
end
