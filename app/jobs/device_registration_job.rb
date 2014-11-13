class DeviceRegistrationJob
  include SuckerPunch::Job

  def perform(args = {})
    user    = args.fetch(:user)
    address = args.fetch(:user)

    SuckerPunch.logger.debug "Update token: User ##{user.id}, address: #{address}"

    ActiveRecord::Base.connection_pool.with_connection do
      mobile_device = user.mobile_device

      if mobile_device.present?
        if address.present? && user.new_address?(address)

          with_response_logger { ZeroPush.unregister(mobile_device.address) }
          user.mobile_device.update_attributes(address: address)
          with_response_logger { ZeroPush.register(address) }
        end
      else
        user.create_mobile_device(address: address)

        with_response_logger { ZeroPush.register(address) } if address.present?
      end
    end
  end

  def with_response_logger
    yield.tap do |resp|
      SuckerPunch.logger.debug resp.inspect
    end
  end
end

