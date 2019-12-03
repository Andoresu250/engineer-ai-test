class TweetSerializer < ActiveModel::Serializer
  attributes :id, :message, :created_at, :updated_at
  has_one :user
end
