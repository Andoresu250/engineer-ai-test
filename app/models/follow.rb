class Follow < ApplicationRecord

  belongs_to :follower, foreign_key: :follower_id, class_name: 'User'
  belongs_to :following, foreign_key: :following_id, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :following_id, message: 'Already following' }
  validate :user_cant_follow_yourself

  def user_cant_follow_yourself
    if follower_id.present? && following_id.present?
      errors.add(:follower_id, 'you can not follow your self') if follower_id == following_id
    end
  end

end
