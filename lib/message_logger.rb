module MessageLogger
  extend self

  delegate :debug, :info, :warn, :error, to: :logger

  def print_error(msg)
    error(msg.message)
    debug(msg.backtrace.join("\n"))
  end

  private

  def logger
    Rails.logger
  end
end
