class APNConnection
  def initialize
    setup
  end

  def setup
    @uri = if Settings.apns.env == 'prod'
             Houston::APPLE_PRODUCTION_GATEWAY_URI
           else
             Houston::APPLE_DEVELOPMENT_GATEWAY_URI
           end

    @certificate = File.read(File.join(Rails.root, 'certificates', Settings.apns.cert))
    @passphrase = Settings.apns.passphrase

    @connection = Houston::Connection.new(@uri, @certificate, @passphrase)
    @connection.open
  end

  def write(data)
    begin
      unless @connection.open?
        Rails.logger.error "Connection is closed. Retrying..."
        raise "Connection is closed"
      end

      @connection.write(data)
    rescue Exception => e
      attempts ||= 0
      attempts += 1

      if attempts < 5
        setup
        retry
      else
        raise e
      end
    end
  end

end
