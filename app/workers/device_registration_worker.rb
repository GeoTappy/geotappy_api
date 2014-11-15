class DeviceRegistrationWorker < BaseWorker
  sidekiq_options retry: 5, backtrace: true

  def perform(args = {})
    with_connection do
      device  = MobileDevice.find(args.fetch('mobile_device_id'))

      logger.info "Register device #{device.inspect}"

      with_response_logger do
        ZeroPush.register(device.address)
      end
    end
  end

  def with_response_logger
    yield.tap do |resp|
      logger.debug resp.inspect
    end
  end
end

