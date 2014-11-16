class PushNotificationWorker < BaseWorker
  sidekiq_options retry: 5, backtrace: true

  def perform(args = {})
    with_connection do
      share = Share.find(args.fetch('share_id'))
      device_tokens = device_tokens_for(share)

      APNSWorker.new.perform(*PushNotification.new(share, device_tokens).args)
    end
  end

  private

  def device_tokens_for(share)
    MobileDevice.select(:address)
      .where(user_id: share.user_shares.map(&:user_id))
      .map(&:address).compact
  end
end

