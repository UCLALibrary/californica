# frozen_string_literal: true
class ApplicationJob < ActiveJob::Base
  include Sidekiq::Status::Worker

  attr_accessor :jid

  before_perform do |job|
    job.jid = job.provider_job_id
  end
end
