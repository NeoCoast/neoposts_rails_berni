# frozen_string_literal: true

# :reek:UncommunicativeModuleName
module Api
  module V1
    # class APIPostsController
    class PostsController < ApplicationController
      before_action :find_post, only: :show

      def create
        @post = current_user.posts.new(post_params)
        if @post.save
          render partial: 'api/v1/posts/post', locals: { post: @post }
        else
          render json: {
            errors: @post.errors
          }
        end
      end

      def show; end

      def index
        followed_posts = current_user.following
        @posts = Post.where(user_id: followed_posts.map(&:id))
                     .page(params[:page])
                     .per(params[:per_page])
                     .scope_order(params[:order] || 'DESC')
                     .scope_search(params[:search] || '')
      end

      private

      def post_params
        params.require(:post).permit(:title, :body, :image)
      end

      def find_post
        @post = Post.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: {
          error: 'Post not found!'
        }
      end
    end
  end
end
