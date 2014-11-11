class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  has_many :auth_providers

  has_many :user_friendships, dependent: :delete_all
  has_many :friends, through: :user_friendships

  # TODO: Demo mode, user has only one device now
  has_one :mobile_device, dependent: :delete

  has_many :shares
  has_many :user_shares
  has_many :shared_locations, through: :user_shares

  has_many :locations

  def self.with_email(email)
    return if email.blank?

    where(email: email).first
  end

  def find_friend(id)
    friendship = user_friendships.includes(:friend)
      .where(friend_id: id)
      .first

    raise ActiveRecord::RecordNotFound if friendship.nil?

    friendship.friend
  end

  def update_push_token(token)
    QueueDispatchers::DeviceRegistration.publish({
      token:   token.to_s.gsub(' ', ''),
      user_id: id
    })
  end

  def access_token
    Doorkeeper::AccessToken.where(resource_owner_id: id).first
  end

  def new_address?(address)
    mobile_device.try(:address) != address
  end
end
