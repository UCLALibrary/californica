# frozen_string_literal: true
class ApplicationJob < ActiveJob::Base
  include Sidekiq::Status::Worker

  attr_accessor :jid

  before_perform do |job|
    job.jid = job.provider_job_id
    redis = Redis.current
    redis.set(redis_key, 'false')
  end

  around_enqueue do |_, block|
    if deduplication_key
      redis = Redis.current
      unless redis.get(redis_key) == 'true'
        redis.set(redis_key, 'true')
        block.call
      end
    else
      block.call
    end
  end

  def deduplication_key
    nil
  end

  def redis_key
    (@redis_key ||= "in_queue_#{deduplication_key}") if deduplication_key
  end
end
