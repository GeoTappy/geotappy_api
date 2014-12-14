class APNSWorker < BaseWorker
  sidekiq_options queue: :push, retry: 5, backtrace: true

  # APN_POOL = ConnectionPool.new(size: 1, timeout: 300) do
  #  APNConnection.new
  # end

  def perform(addresses, message, notification_options = {})
    mobile_tokens = Array(addresses)

    if mobile_tokens.empty?
      logger.warn "No mobile tokens found"
      return
    end

    logger.info "Sending push notification: [#{addresses}, message: #{message}, data: #{notification_options}]"

    mobile_tokens.each do |token|
      notification = Houston::Notification.new(
        { device: token, alert: message }.merge(notification_options)
      )

      APN.push(notification)

      logger.info "Send push notification to #{token} (Error: #{notification.error})"
    end
  end
end
