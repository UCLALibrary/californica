# frozen_string_literal: true
require 'rails_helper'
require 'rake'

RSpec.describe 'californica:ingest:csv', :clean do
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
    let(:title) do
      "Protesters with signs in gallery of Los Angeles County Supervisors " \
      "hearing over eminent domain for construction of Harbor Freeway, Calif., 1947"
    end
    let(:description) { ["At the Hall of Records, 220 N. Broadway.", "Description 2"] }
    let(:subj) do
      ["Express highways--California--Los Angeles County--Design and construction",
       "Eminent domain--California--Los Angeles",
       "Demonstrations--California--Los Angeles County",
       "Transportation",
       "Government",
       "Activism",
       "Interstate 10"]
    end

    it 'has created a work with the correct metadata' do
      expect(created_work.title).to contain_exactly(title)
      expect(created_work.description).to contain_exactly(*description)
      expect(created_work.subject).to contain_exactly(*subj)
      expect(created_work.resource_type).to eq ['still image']
      expect(created_work.extent).to eq ['1 photograph']
      expect(created_work.local_identifier).to eq ['uclalat_1387_b107_40098']
      expect(created_work.latitude).to eq ['34.054133']
      expect(created_work.longitude).to eq ['-118.243865']
      expect(created_work.date_created).to eq ['September 17, 1947']
      expect(created_work.caption).to eq ['This example does not have a caption.']
      expect(created_work.dimensions).to eq ['10 x 12.5 cm.']
      expect(created_work.funding_note).to eq ['Info about funding']
      expect(created_work.genre).to eq ['news photographs']
      expect(created_work.rights_holder).to eq ['UCLA Charles E. Young Research Library Department of Special Collections, A1713 Young Research Library, Box 951575, Los Angeles, CA 90095-1575. E-mail: spec-coll@library.ucla.edu. Phone: (310)825-4988']
      expect(created_work.rights_country).to eq ['US']
      expect(created_work.medium).to eq ['1 photograph']
      expect(created_work.normalized_date).to eq ['1947-09-17']
      expect(created_work.repository).to eq ['University of California, Los Angeles. Library. Department of Special Collections']
      expect(created_work.location).to eq ['Los Angeles (Calif.)']
      expect(created_work.publisher).to eq ['Los Angeles Daily News']
      expect(created_work.named_subject).to eq ['Los Angeles County (Calif.). Board of Supervisors']
    end

    it 'has created a public work' do
      expect(created_work.visibility)
        .to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end
