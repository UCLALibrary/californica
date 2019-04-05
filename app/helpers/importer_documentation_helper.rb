# frozen_string_literal: true

# Render markdown to create page anchors so the table of contents can
# link within the page.
# These are the methods we can override:
# https://github.com/vmg/redcarpet/blob/master/README.markdown#block-level-calls
# Redcarpet is supposed to have a `with_toc_data` option but it appears to be broken.
class CustomRender < Redcarpet::Render::HTML
  def header(text, header_level)
    return %(<h1>#{text}</h1>) if header_level == 1

    required = text.include?("(required)")
    text = text.gsub(" (required)", "")

    if required
      %(<a id=#{text.downcase.tr(' ', '-')}></a><h#{header_level}>#{text}<span class="label label-info required-tag">required</span></h#{header_level}>)
    else
      %(<a id=#{text.downcase.tr(' ', '-')}></a><h#{header_level}>#{text}</h#{header_level}>)
    end
  end
end

module ImporterDocumentationHelper
  def render_guide
    markdown = Redcarpet::Markdown.new(CustomRender, fenced_code_blocks: true, autolink: true)
    markdown.render(File.open(Rails.root.join('app', 'assets', 'markdown', 'importer_guide.md')).read)
  end
end
