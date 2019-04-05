# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "importer_documentation/guide.html.erb", type: :view do
  it 'renders as html' do
    render
    expect(rendered).to match(/<a id=title><\/a><h3>Title<\/h3>/)
    expect(rendered).to match(/<a id=item-ark><\/a><h3>Item Ark<\/h3>/)
  end
end
