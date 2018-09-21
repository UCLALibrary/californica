# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaLogStream do
  subject(:stream) { described_class.new }

  # reach into the logger to find the filename
  let(:filename) { stream.logger.instance_variable_get(:@logdev).filename }

  describe '#<<' do
    let(:message) { 'a message' }

    it 'writes to a log' do
      stream << message

      expect(File.readlines(filename).each(&:chomp!).last).to match(/#{message}/)
    end

    it 'writes with default level of INFO' do
      stream << message

      expect(File.readlines(filename).each(&:chomp!).last).to match(/INFO/)
    end

    context 'with a custom logger' do
      subject(:stream) { described_class.new(logger: logger) }
      let(:logger)     { Logger.new(log_device) }
      let(:log_device) { StringIO.new }

      it 'logs to the custom logger' do
        stream << message

        log_device.rewind
        expect(log_device.read).to match(/#{message}/)
      end
    end

    context 'with a custom severity' do
      subject(:stream) { described_class.new(severity: severity) }
      let(:severity)   { Logger::DEBUG }

      it 'logs with the custom severity' do
        stream << message

        expect(File.readlines(filename).each(&:chomp!).last).to match(/DEBUG/)
      end
    end
  end
end
