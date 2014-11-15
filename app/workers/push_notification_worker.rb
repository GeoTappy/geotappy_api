class PushNotificationWorker < BaseWorker
  sidekiq_options queue: 'push', retry: 5, backtrace: true

  def perform(args = {})
    with_connection do
      share = Share.find(args.fetch('share_id'))

      device_tokens = device_tokens_for(share)

      logger.info "Sending push notification to: #{device_tokens.inspect}, Message: #{share.notification_message}, opts: #{share.notification_options}"

      PushNotification.new(device_tokens).notify(
        share.notification_message,
        share.notification_options
      )
    end
  end

  private

  def device_tokens_for(share)
    MobileDevice.select(:address)
      .where(user_id: share.user_shares.map(&:user_id))
      .map(&:address).compact
  end
end

