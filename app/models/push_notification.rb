class PushNotification
  def initialize(device_tokens)
    self.device_tokens = device_tokens
  end

  def notify(message, options = {})
    return if device_tokens.empty?

    notification = default_options.merge(
      push_options(message, options)
    )

    Rails.logger.info "Sending push notification: #{notification.inspect}"

    ZeroPush.notify(notification).tap do |push|
      Rails.logger.debug push.inspect
    end
  end

  private

  attr_accessor :device_tokens

  def push_options(message, options)
    options.merge(
      device_tokens: device_tokens,
      alert:         message
    )
  end

  def default_options
    @default_options ||= {
      sound: "default",
      badge: 1
    }
  end
end
