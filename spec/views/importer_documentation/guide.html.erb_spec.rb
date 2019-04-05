# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "importer_documentation/guide.html.erb", type: :view do
  it 'renders as html' do
    render
    expect(rendered).to match(/<a id=title><\/a><h3>Title<span class="label label-info required-tag">required<\/span><\/h3>/)
  end
end
