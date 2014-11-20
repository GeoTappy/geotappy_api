class User < ActiveRecord::Base
  DEFAULT_COVER_URL = 'https://api.geotappy.com/cover.jpg'
  GENDER = {
    'male'   => 0,
    'female' => 1
  }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  has_many :auth_providers

  has_many :user_friendships, dependent: :delete_all
  has_many :friends, through: :user_friendships

  # TODO: Demo mode, user has only one device now
  has_many :mobile_devices, dependent: :delete_all

  has_many :shares,      dependent: :destroy
  has_many :user_shares, dependent: :delete_all
  has_many :shared_locations, through: :user_shares

  has_many :locations, dependent: :delete_all

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

  def cover_photo_url
    read_attribute(:cover_photo_url).presence || DEFAULT_COVER_URL
  end

  def gender=(gender_name)
    write_attribute(:gender, GENDER[gender_name] || nil)
  end

  def gender
    GENDER.invert[read_attribute(:gender)]
  end

  def pronoun
    case gender
    when 'male'   then 'his'
    when 'female' then 'her'
    else 'a'
    end
  end

  def update_push_token(token)
    DeviceRegistrationJob.new.async.perform(
      user: self,
      address: token.to_s.gsub(' ', '')
    )
  end

  def access_token
    Doorkeeper::AccessToken.where(resource_owner_id: id).first
  end

  def new_address?(address)
    mobile_device.try(:address) != address
  end

  def email_required?
    false
  end
end
