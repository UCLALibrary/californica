# frozen_string_literal: true
require 'rails_helper'

class TestJob < ApplicationJob
  def perform; end
end

class DeduplicatedJob < TestJob
  def deduplication_key
    'abc123'
  end
end

RSpec.describe ApplicationJob, type: :job do
  after { Redis.current.del('in_queue_abc123') }

  describe '#perform_later' do
    context 'when #deduplication_key is not set' do
      it 'always enqueues the job' do
        expect do
          TestJob.perform_later
          TestJob.perform_later
        end.to have_enqueued_job(TestJob).exactly(:twice)
      end
    end

    context 'when #deduplication_key is set on a subclass' do
      it 'only enqueues the job if it\'s not in the queue already' do
        expect do
          DeduplicatedJob.perform_later
          DeduplicatedJob.perform_later
          DeduplicatedJob.perform_now
        end.to have_enqueued_job(DeduplicatedJob).exactly(:once)
      end

      it 'allows a job to be enqueued again after it has run' do
        expect do
          DeduplicatedJob.perform_later
          DeduplicatedJob.perform_now
          DeduplicatedJob.perform_later
        end.to have_enqueued_job(DeduplicatedJob).exactly(:twice)
      end
    end
  end

  describe '#deduplication_key' do
    it 'returns nil by default' do
      expect(TestJob.new.deduplication_key).to be_nil
    end
  end

  describe '#redis_key' do
    context 'when #deduplication_key is not set' do
      it 'is nil' do
        expect(TestJob.new.redis_key).to be_nil
      end
    end

    context 'when #deduplication_key is set on a subclass' do
      before { allow_any_instance_of(TestJob).to receive(:deduplication_key).and_return('abc123') }

      it 'is based on #deduplication_key' do
        expect(TestJob.new.redis_key).to eq 'in_queue_abc123'
      end
    end
  end
end
