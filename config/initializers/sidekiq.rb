Sidekiq::Logging.logger  = Syslogger.new(
    'geotappy_sidekiq', Syslog::LOG_CONS, Syslog.const_get(Settings.logger.facility)
  ).tap do |logger|
    logger.level = Logger.const_get(Settings.logger.level.upcase)
  end
