class TweetsController < ApplicationController

  before_action :authenticate_user!, only: %i[index create destroy update]
  before_action :set_tweet, only: %i[show update destroy]
  before_action :validate_owner, only: %i[update destroy]
  before_action :set_user, only: :index

  def index
    tweets = if @user
               @user.tweets.super_paginate(params)
             else
               Tweet.by_follower(current_user.id).super_paginate(params)
             end
    render_collection('tweets', tweets, TweetSerializer)
  end

  def create
    tweet = current_user.tweets.build(tweet_params)
    tweet.save
    render_resource(tweet)
  end

  def show
    render_resource(@tweet)
  end

  def update
    @tweet.assign_attributes(tweet_params)
    @tweet.save
    render_resource(@tweet)
  end

  def destroy
    @tweet.destroy
  end

  private

  def tweet_params
    params.permit(:message)
  end

  def set_tweet
    render_not_found unless (@tweet = Tweet.find_by(id: params[:id]))
  end

  def validate_owner
    render_owner_error unless @tweet.user == current_user
  end

  def set_user
    if params[:user_id].present?
      render_not_found unless (@user = User.find_by(id: params[:user_id]))
    end
  end

end
