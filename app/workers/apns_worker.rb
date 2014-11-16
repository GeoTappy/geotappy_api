class APNSWorker < BaseWorker
  sidekiq_options queue: :push, retry: 5, backtrace: true

  APN_POOL = ConnectionPool.new(size: 2, timeout: 300) do
    APNConnection.new
  end

  def perform(addresses, message, notification_options = {})
    mobile_tokens = Array(addresses)

    if mobile_tokens.empty?
      logger.warn "No mobile tokens found"
      return
    end

    logger.info "Sending push notification: [#{addresses}, message: #{message}, data: #{notification_options}]"

    APN_POOL.with do |connection|
      mobile_tokens.each do |token|
        notification = Houston::Notification.new(
          { device: token, alert: message }.merge(notification_options)
        )
        connection.write(notification.message)
      end
    end
  end
end
