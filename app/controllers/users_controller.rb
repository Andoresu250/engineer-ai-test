class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user, except: %i[profile tweets]
  before_action :set_following_relationship, only: :unfollow

  def profile
    render_resource(current_user)
  end

  def tweets
    render_collection('tweets', current_user.tweets.super_paginate(params), TweetSerializer)
  end

  def follow
    following_relationship = current_user.following_relationships.build(following: @user)
    if following_relationship.save
      render_resource(current_user.reload)
    else
      render_resource(following_relationship)
    end
  end

  def unfollow
    @following_relationship.destroy
  end

  def set_user
    render_not_found unless ( @user = User.find_by(id: params[:id]) )
  end

  def set_following_relationship
    @following_relationship = current_user.following_relationships.find_by(following: @user)
    render_error(message: 'You do not follow this user') if @following_relationship.nil?
  end

end
