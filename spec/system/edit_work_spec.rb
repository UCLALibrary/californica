# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Edit an existing work', :clean, type: :system, js: true do
  let(:work) { Work.create!(work_attrs) }

  let(:work_attrs) do
    {
      access_copy: 'dlmasters/ethiopian/masters/abc123.tif',
      alternative_title: ['Alternative title'],
      architect: ['Old Architect'],
      ark: 'ark:/abc/3456',
      artist: ['Old Artist'],
      author: ['Old Author'],
      binding_note: 'Old Binding note',
      calligrapher: ['Old Calligrapher'],
      caption: ['Old Caption'],
      cartographer: ['Old Cartographer'],
      citation_source: ['References'],
      collation: 'Old Collation',
      colophon: ['Old Colophon'],
      composer: ['Old Composer'],
      commentator: ['Old Commentator'],
      condition_note: 'Old Condition note',
      content_disclaimer: ['Old Disclaimer'],
      contents_note: ['Old Contents note'],
      contributor: ['Old Contributor'],
      creator: ['Old Creator'],
      date_created: ['Old Creation Date'],
      description: ['Old Desc'],
      dimensions: ['Old Dim'],
      director: ['Old Director'],
      editor: ['Old Editor'],
      engraver: ['Old Engraver'],
      extent: ['Old Extent'],
      featured_image: 'Old Featured image',
      finding_aid_url: ['Old Finding aid url'],
      foliation: 'Old Foliation note',
      funding_note: ['Old Fund Note'],
      genre: ['Old Genre'],
      host: ['Old Host'],
      iiif_manifest_url: 'https://www.w3.org/TR/2019/WD-appmanifest-20190821/',
      iiif_range: 'Old Iiif range',
      iiif_text_direction: 'http://iiif.io/api/presentation/2#leftToRightDirection', # "left-to-right"
      iiif_viewing_hint: 'Old Iiif viewing hint',
      illuminator: ['Old Illuminator'],
      illustrations_note: ['Old Illustrations note'],
      illustrator: ['Old Illustrator'],
      interviewer: ['Old Interviewer'],
      interviewee: ['Old Interviewee'],
      language: ['ang'],
      latitude: ['Old Lat'],
      license: ['http://creativecommons.org/publicdomain/zero/1.0/'],
      local_identifier: ['Old Local ID'],
      # local_rights_statement: ['Old Rights statement local'] # This invokes License renderer from hyrax gem
      location: ['Old Loc'],
      longitude: ['Old Long'],
      lyricist: ['Old Lyricist'],
      masthead_parameters: 'Old Masthead Parameters',
      medium: ['Old Medium'],
      musician: ['Old Musician'],
      named_subject: ['Old Name/Subj'],
      normalized_date: ['1900/1901'],
      note: ['Old Note'],
      opac_url: 'https://www.library.ucla.edu',
      page_layout: ['Old Page layout'],
      photographer: ['Old Photographer'],
      place_of_origin: ['Old Place of origin'],
      preservation_copy: 'dlmasters/ethiopian/masters/abc123.tif',
      printer: ['Old Printer'],
      printmaker: ['Old printmaker'],
      producer: ['Old Producer'],
      program: ['Old Program'],
      provenance: ['Old Provenance'],
      publisher: ['Old Pub'],
      recipient: ['Old Recipient'],
      repository: ['Old Repository'],
      representative_image: 'Old Representative image',
      researcher: ['Old Researcher'],
      resource_type: ['http://id.loc.gov/vocabulary/resourceTypes/img'], # "image"
      resp_statement: ['Old Statement of Responsibility'],
      rights_country: ['Old Rights Country'],
      rights_holder: ['Old Rights Holder'],
      rights_statement: ['http://vocabs.library.ucla.edu/rights/copyrighted'], # "copyrighted"
      rubricator: ['Old rubricator'],
      scribe: ['Old Scribe'],
      series: ['Old Series'],
      subject: ['Old Subj'],
      subject_cultural_object: ['Old Subject cultural object'],
      subject_domain_topic: ['Old Subject domain topic'],
      subject_geographic: ['Old Subject geographic'],
      subject_temporal: ['Old Subject temporal'],
      subject_topic: ['Old Subject topic'],
      summary: ['Old Summary'],
      support: ['Old Support'],
      tagline: 'Old Tagline',
      title: ['Old Title'],
      thumbnail_link: 'https://fake.url/iiif/ark%3A%2Fabc%2F3456',
      toc: ['Old Table of contents'],
      translator: ['Old Translator'],
      uniform_title: ['Old Uniform title']
    }
  end

  include_context 'with workflow'

  context 'logged in as an admin user' do
    let(:admin) { FactoryBot.create :admin }

    before { login_as admin }

    scenario 'successfully edits the work' do
      visit edit_hyrax_work_path(work.id)

      # When the form first loads, it should contain all the old values
      expect(find_field('Title').value).to eq 'Old Title'
      expect(find_field('Ark').value).to eq 'ark:/abc/3456'
      expect(page.all(:css, 'div.select.work_rights_statement').first.has_content?('copyrighted')).to eq true

      click_on 'Additional fields'
      expect(find_field('Access copy').value).to eq 'dlmasters/ethiopian/masters/abc123.tif'
      expect(find_field('Alternative title').value).to eq 'Alternative title'
      expect(find_field('Architect').value).to eq 'Old Architect'
      expect(find_field('Artist').value).to eq 'Old Artist'
      expect(find_field('Author').value).to eq 'Old Author'
      expect(find_field('Binding note').value).to eq 'Old Binding note'
      expect(find_field('Caption').value).to eq 'Old Caption'
      expect(find_field("Cartographer").value).to eq 'Old Cartographer'
      expect(find_field('Collation').value).to eq 'Old Collation'
      expect(find_field('Colophon').value).to eq 'Old Colophon'
      expect(find_field('Composer').value).to eq 'Old Composer'
      expect(find_field('Commentator').value).to eq 'Old Commentator'
      expect(find_field('Condition note').value).to eq 'Old Condition note'
      expect(find_field("Content disclaimer").value).to eq 'Old Disclaimer'
      expect(find_field('Contents note').value).to eq 'Old Contents note'
      expect(find_field('Creator').value).to eq 'Old Creator'
      expect(find_field('Date Created').value).to eq 'Old Creation Date'
      expect(find_field('Dimensions').value).to eq 'Old Dim'
      expect(find_field("Director").value).to eq 'Old Director'
      expect(find_field('Editor').value).to eq 'Old Editor'
      expect(find_field('Engraver').value).to eq 'Old Engraver'
      expect(find_field('Extent').value).to eq 'Old Extent'
      expect(find_field('Featured image').value).to eq 'Old Featured image'
      expect(find_field('Finding aid url').value).to eq 'Old Finding aid url'
      expect(find_field('Foliation').value).to eq 'Old Foliation note'
      expect(find_field('Funding Note').value).to eq 'Old Fund Note'
      expect(find_field('Genre').value).to eq 'Old Genre'
      expect(find_field("Host").value).to eq 'Old Host'
      expect(find_field('Iiif manifest url').value).to eq 'https://www.w3.org/TR/2019/WD-appmanifest-20190821/'
      expect(page).to have_select('Iiif text direction', selected: 'left-to-right', multiple: false)
      expect(find_field('Illuminator').value).to eq 'Old Illuminator'
      expect(find_field("Interviewee").value).to eq 'Old Interviewee'
      expect(find_field("Interviewer").value).to eq 'Old Interviewer'
      expect(page).to have_select('Language', selected: 'English, Old (ca. 450-1100)', multiple: true)
      expect(find_field('Latitude').value).to eq 'Old Lat'
      expect(find_field('Local Identifier').value).to eq 'Old Local ID'
      expect(find_field('Location').value).to eq 'Old Loc'
      # expect(find_field('Local rights statement').value).to eq 'Old Rights statement local'
      expect(find_field('Longitude').value).to eq 'Old Long'
      expect(find_field('Lyricist').value).to eq 'Old Lyricist'
      expect(find_field('Masthead parameters').value).to eq 'Old Masthead Parameters'
      expect(find_field('Medium').value).to eq 'Old Medium'
      expect(find_field("Musician").value).to eq 'Old Musician'
      expect(find_field('Name (Subject)').value).to eq 'Old Name/Subj'
      expect(find_field('Normalized Date').value).to eq '1900/1901'
      expect(find_field('Page layout').value).to eq 'Old Page layout'
      expect(find_field('Photographer').value).to eq 'Old Photographer'
      expect(find_field('Place of origin').value).to eq 'Old Place of origin'
      expect(find_field('Preservation copy').value).to eq 'dlmasters/ethiopian/masters/abc123.tif'
      expect(find_field("Printer").value).to eq 'Old Printer'
      expect(find_field("Producer").value).to eq 'Old Producer'
      expect(find_field("Program").value).to eq 'Old Program'
      expect(find_field('Publisher').value).to eq 'Old Pub'
      expect(find_field('Repository').value).to eq 'Old Repository'
      expect(find_field('Resource type').value).to eq ['http://id.loc.gov/vocabulary/resourceTypes/img']
      expect(find_field('Statement of Responsibility').value).to eq 'Old Statement of Responsibility'
      expect(find_field('Rights (country of creation)').value).to eq 'Old Rights Country'
      expect(find_field('Rights Holder').value).to eq 'Old Rights Holder'
      expect(find_field('Subject').value).to eq 'Old Subj'
      expect(find_field('Subject topic').value).to eq 'Old Subject topic'
      expect(find_field('Summary').value).to eq 'Old Summary'
      expect(find_field('Opac url').value).to eq 'https://www.library.ucla.edu'
      expect(first(:css, '#work_description').value).to eq 'Old Desc'
      expect(find_field("Recipient").value).to eq 'Old Recipient'
      expect(find_field('References').value).to eq 'Old References'
      expect(find_field('Representative image').value).to eq 'Old Representative image'
      expect(find_field("Researcher").value).to eq 'Old Researcher'
      expect(find_field('Rubricator').value).to eq 'Old rubricator'
      expect(find_field('Scribe').value).to eq 'Old Scribe'
      expect(find_field('Series').value).to eq 'Old Series'
      expect(find_field('Subject geographic').value).to eq 'Old Subject geographic'
      expect(find_field('Subject temporal').value).to eq 'Old Subject temporal'
      expect(find_field('Subject cultural object').value).to eq 'Old Subject cultural object'
      expect(find_field('Subject domain topic').value).to eq 'Old Subject domain topic'
      expect(find_field('Tagline').value).to eq 'Old Tagline'
      expect(find_field('Thumbnail link').value).to eq 'https://fake.url/iiif/ark%3A%2Fabc%2F3456'
      expect(page).to have_select('License', selected: 'Creative Commons CC0 1.0 Universal', multiple: false)
      expect(find_field('Translator').value).to eq 'Old Translator'
      expect(find_field('Uniform title').value).to eq 'Old Uniform title'

      # Edit some fields in the form
      fill_in 'Title', with: 'New Title'
      fill_in 'Dimensions', with: 'New Dim'
      fill_in 'Ark', with: 'ark:/not/myark' # This field is read-only and an attempt to change it should not result in a change
      fill_in 'Thumbnail link', with: 'https://new.url/iiif/ark%3A%2Fabc%2F3456'
      click_on 'Additional fields'
      # Submit the form.  When the page reloads, it should be on the show page.
      click_on 'Save changes'
      expect(page).to have_current_path(hyrax_work_path(work.id, locale: I18n.locale))

      # When the show page loads, it should have the new values
      expect(page).to have_content 'New Title'
      expect(page).to_not have_content 'Old Title'
      expect(page).to have_content 'New Dim'
      expect(page).to_not have_content 'Old Dim'
      expect(page).to have_content 'ark:/abc/3456'
      expect(page).to_not have_content 'ark:/not/myark'
      expect(page).to have_content 'https://new.url/iiif/ark%3A%2Fabc%2F3456'
      expect(page).to_not have_content 'https://fake.url/iiif/ark%3A%2Fabc%2F3456'
    end
  end
end
