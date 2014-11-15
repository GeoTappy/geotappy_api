class UserFriendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def self.friends_for(user, ids = nil)
    if ids.present?
      where(user_id: user.id, friend_id: ids).includes(:friend).map(&:friend)
    else
      where(user_id: user.id).includes(:friend).map(&:friend)
    end
  end

  def self.friends_exists?(user, ids = nil)
    if ids.present?
      where(user_id: user.id, friend_id: ids).exists?
    else
      where(user_id: user.id).exists?
    end
  end

  def self.create_if_new(user, friend)
    return if user.id == friend.id
    return if where(user_id: user.id, friend_id: friend.id).exists?
    return if where(friend_id: user.id, user_id: friend.id).exists?

    new(user_id: user.id,   friend_id: friend.id).save
    new(user_id: friend.id, friend_id: user.id).save
  end

  def self.remove_friendship(user, friend)
    where(
      '(user_id = :user_id AND friend_id = :friend_id) OR (user_id = :friend_id AND friend_id = :user_id)',
      user_id: user.id, friend_id: friend.id
    ).destroy_all
  end

  def self.remove_connections(user)
    sql = 'user_id = :user_id OR friend_id = :user_id'

    where(sql, user_id: user.id).destroy_all
  end
end
