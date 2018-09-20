# frozen_string_literal: true

class CalifornicaLogStream
  ##
  # @!attribute [rw] logger
  #   @return [Logger]
  # @!attribute [rw] severity
  #   @return [Logger::Serverity]
  attr_accessor :logger, :severity

  def initialize(logger: nil, severity: nil)
    self.logger   = logger   || Logger.new(build_filename)
    self.severity = severity || Logger::INFO
  end

  def <<(msg)
    logger.add(severity, msg)
  end

  private

    def build_filename
      timestamp = Time.zone.now.strftime('%Y-%m-%d-%H-%M-%S')

      Rails.root.join('log', "ingest_#{timestamp}.log").to_s
    end
end
