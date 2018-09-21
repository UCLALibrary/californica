# frozen_string_literal: true

RSpec.shared_context 'with workflow' do
  before :context do
    admin_set_id        = AdminSet.find_or_create_default_admin_set_id
    permission_template = Hyrax::PermissionTemplate.find_or_create_by!(source_id: admin_set_id)
    workflow            = Sipity::Workflow.create!(active:              true,
                                                   name:                'test-workflow',
                                                   permission_template: permission_template)

    # Create a single action that can be taken
    Sipity::WorkflowAction.create!(name: 'submit', workflow: workflow)
  end

  after(:context) do
    ActiveFedora::Cleaner.clean!
    DatabaseCleaner.clean
  end
end
