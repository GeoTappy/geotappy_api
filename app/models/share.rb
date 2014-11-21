class Share < ActiveRecord::Base
  belongs_to :user

  has_one :location,     dependent: :destroy
  has_many :user_shares, dependent: :destroy

  def notification_message
    title.presence || I18n.t('current_location', name: user.first_name, pronoun: user.pronoun)
  end

  def notification_options
    {
      info: {
        sender: {
          id: user.id,
          name: [user.first_name, user.last_name].compact.join(' '),
          profile_photo_url: user.profile_photo_url
        },
        location: {
          lat: location.lat.to_f,
          lng: location.lng.to_f,
          name: location.place_name
        }
      }
    }
  end

  def send_push_notifications
    PushNotificationWorker.perform_async('share_id' => id)
  end
end
