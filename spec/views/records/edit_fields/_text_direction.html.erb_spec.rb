require 'rails_helper'
RSpec.describe 'records/edit_fields/_text_direction.html.erb', type: :view do
  let(:work) { Work.new }
  let(:form) { Hyrax::WorkForm.new(work, {}, {}) }
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "records/edit_fields/text_direction", f: f, key: 'text_direction' %>
      <% end %>
    )
  end

  before do
    assign(:form, form)
    render inline: form_template
  end


  #it 'should be true if a field with the given partial options is on the page' do
  #      expect(rendered).to have_select('work_text_direction', with_options: %w[left-to-right,right-to-left])
  #end

end
