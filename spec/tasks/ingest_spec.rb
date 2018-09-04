# frozen_string_literal: true
require 'rails_helper'
require 'rake'

RSpec.describe 'californica:ingest:csv' do
  subject(:task)  { rake[task_name] }
  let(:csv_path)  { 'spec/fixtures/example.csv' }
  let(:rake)      { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }
  let(:task_path) { 'lib/tasks/ingest' }

  def loaded_files_excluding_current_rake_file
    $LOADED_FEATURES.reject { |f| f == Rails.root.join("#{task_path}.rake").to_s }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], loaded_files_excluding_current_rake_file)
    Rake::Task.define_task(:environment)
  end

  context 'after sucessful task run' do
    before { task.invoke(csv_path) }

    let(:created_work) { Work.where(identifier_tesim: '21198/zz0002nq4w').first }

    it 'has created a work with the correct title' do
      title = "Protesters with signs in gallery of Los Angeles County Supervisors " \
              "hearing over eminent domain for construction of Harbor Freeway, Calif., 1947"

      expect(created_work.title).to contain_exactly(title)
    end
  end
end
