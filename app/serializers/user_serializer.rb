class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username
  has_many :followers
  has_many :followings
end
