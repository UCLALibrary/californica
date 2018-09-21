# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ActorRecordImporter do
  subject(:importer) do
    described_class.new(error_stream: error_stream, info_stream: info_stream)
  end

  let(:record)        { Darlingtonia::InputRecord.from(metadata: metadata_hash) }
  let(:error_stream)  { [] }
  let(:info_stream)   { [] }
  let(:metadata_hash) { { 'title' => ['Comet in Moominland'] } }

  describe '#import' do
    let(:admin_set_id) { AdminSet.find_or_create_default_admin_set_id }

    let(:permission_template) do
      Hyrax::PermissionTemplate.find_or_create_by!(source_id: admin_set_id)
    end

    let(:workflow) do
      Sipity::Workflow.create!(active:              true,
                               name:                'test-workflow',
                               permission_template: permission_template)
    end

    before do
      # Create a single action that can be taken
      Sipity::WorkflowAction.create!(name: 'submit', workflow: workflow)

      # Grant the user access to deposit into the admin set.
      Hyrax::PermissionTemplateAccess.create!(
        permission_template_id: permission_template.id,
        agent_type: 'user',
        agent_id: User.find_or_create_system_user(described_class::DEFAULT_CREATOR_KEY),
        access: 'deposit'
      )
    end

    it 'creates a work for record' do
      expect { importer.import(record: record) }
        .to change { Work.count }
        .by 1
    end

    it 'writes to the info_stream before and after create' do
      expect { importer.import(record: record) }
        .to change { info_stream }
        .to contain_exactly(/^Creating record/, /^Record created/)
    end

    context 'with an invalid input record' do
      let(:record) { Darlingtonia::InputRecord.new } # no title

      it 'logs an error' do
        expect { importer.import(record: record) }
          .to change { error_stream }
          .to contain_exactly(/^Validation failed: Title/)
      end
    end
  end
end
