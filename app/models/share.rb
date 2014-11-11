class Share < ActiveRecord::Base
  belongs_to :user

  has_one :location

  has_many :user_shares

  def notification_message
    title.presence || I18n.t('current_location', name: user.first_name, location: location.place_name)
  end

  def notification_options
    {
      info: {
        sender: {
          name: [user.first_name, user.last_name].compact.join(' '),
          profile_photo_url: user.profile_photo_url
        },
        location: {
          lat: location.lat,
          lng: location.lng,
          name: location.place_name
        }
      }
    }
  end

  def send_push_notifications
    Celluloid::Actor[:push_notification].process(share: self)
  end
end
