# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvImportTask, type: :model do
  subject(:csv_import_task) do
    FactoryBot.build(:csv_import_task,
                     csv_import_id: 3,
                     job_status: 'Complete',
                     job_type: 'ReindexItemJob',
                     item_ark: 'ark:/123/abc',
                     object_type: 'Work',
                     job_duration: 1.5,
                     times_started: 1,
                     start_timestamp: '2019-10-11 10:38:15:000 PM',
                     end_timestamp: '2019-10-11 10:38:17:000 PM')
  end

  it 'has a parent csv_import record' do
    expect(csv_import_task.csv_import_id).to eq 3
  end

  it 'has job_status' do
    expect(csv_import_task.job_status).to eq 'Complete'
  end

  it 'has job_type' do
    expect(csv_import_task.job_type).to eq 'ReindexItemJob'
  end

  it 'has item_ark' do
    expect(csv_import_task.item_ark).to eq 'ark:/123/abc'
  end

  it 'has object_type' do
    expect(csv_import_task.object_type).to eq 'Work'
  end

  it 'has job_duration' do
    expect(csv_import_task.job_duration).to eq 1.5
  end

  it 'has times_started' do
    expect(csv_import_task.times_started).to eq 1
  end

  it 'has start_timestamp' do
    expect(csv_import_task.start_timestamp).to eq '2019-10-11 10:38:15.000000000 -0700'
  end

  it 'has end_timestamp' do
    expect(csv_import_task.end_timestamp).to eq '2019-10-11 10:38:17.000000000 -0700'
  end
end
