# frozen_string_literal: true

##
# Formats messages from the import process for nicer output
# In the case of CalifornicaImporter, writes all Darlingtonia output to
# the log file for the appropriate ingest run.
class MessageStream
  def initialize(logger)
    @logger = logger
  end

  def <<(msg)
    @logger.info msg.to_s
  end

  def debug(msg)
    @logger.debug msg.to_s
  end

  def info(msg)
    @logger.info msg.to_s
  end

  def warn(msg)
    @logger.warn msg.to_s
  end

  def error(msg)
    @logger.error msg.to_s
  end
end
