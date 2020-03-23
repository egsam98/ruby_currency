module LoggerHelper

  # @param [Symbol]level any of :debug, :info, :warn, :error
  # @param [Exception]e
  def log(level, e)
    Rails.logger.send level, e.backtrace.join("\n")
  end
end