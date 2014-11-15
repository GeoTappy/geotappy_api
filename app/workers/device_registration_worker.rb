class DeviceRegistrationWorker < BaseWorker
  sidekiq_options retry: 3, backtrace: true

  def perform(args = {})
    with_connection do
      user    = User.find(args.fetch('user_id'))
      address = args.fetch('address')

      logger.info "Update token: User ##{user.id}, address: #{address}"

      mobile_device = user.mobile_device

      if mobile_device.present?
        if address.present? && user.new_address?(address)

          with_response_logger do
            ZeroPush.unregister(mobile_device.address)
          end

          user.mobile_device.update_attributes(address: address)

          with_response_logger do
            ZeroPush.register(address)
          end
        end
      else
        user.create_mobile_device(address: address)

        with_response_logger { ZeroPush.register(address) } if address.present?
      end
    end
  end

  def with_response_logger
    yield.tap do |resp|
      logger.debug resp.inspect
    end
  end
end

