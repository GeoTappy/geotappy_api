Sidekiq::Logging.logger  = Syslogger.new(
    'geotappy', Syslog::LOG_PID, Syslog.const_get(Settings.logger.facility)
  ).tap do |logger|
    logger.level = Logger.const_get(Settings.logger.level.upcase)
  end
