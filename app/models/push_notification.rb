class PushNotification
  def initialize(share, device_tokens)
    self.share         = share
    self.device_tokens = device_tokens
  end

  def args
    notification_options = default_options.merge(share.notification_options)

    [device_tokens, share.notification_message, notification_options]
  end

  private

  attr_accessor :device_tokens, :share

  def default_options
    @default_options ||= {
      sound: "default",
      badge: 1
    }
  end
end
