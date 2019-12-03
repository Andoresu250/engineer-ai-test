class Tweet < ApplicationRecord

  scope :by_follower, ->(follower_id) { joins(:follower_relationships).where(follows: {follower_id: follower_id}) }

  validates :message, presence: true, length: { maximum: 120 }

  belongs_to :user
  has_many :follower_relationships, through: :user


end
