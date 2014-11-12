class PushNotificationJob
  include SuckerPunch::Job
  workers 2

  def perform(args = {})
    share = args.fetch(:share)

    ActiveRecord::Base.connection_pool.with_connection do
      device_tokens = device_token_for(share)

      debug "Sending push notification to: #{device_tokens.inspect}, Message: #{share.notification_message}, opts: #{share.notification_options}"

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

