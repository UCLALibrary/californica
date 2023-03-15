# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'hyrax/base/attributes.html.erb', type: :view do
  subject(:page) do
    render 'hyrax/base/attributes.html.erb', presenter: presenter
  end

  let(:admin)         { FactoryBot.create(:admin) }
  let(:ability)       { instance_double('Hyrax::Ability') }
  let(:presenter)     { Hyrax::WorkPresenter.new(solr_document, ability) }
  let(:solr_document) { SolrDocument.new(work.to_solr) }
  let(:work) do
    Work.new(
      ark: 'ark:/abcde/1234567',
      author: ['author'],
      binding_note: 'binding_note',
      calligrapher: ['calligrapher'],
      caption: ['caption'],
      citation_source: ['Old References'],
      colophon: ['Old Colophon'],
      commentator: ['Old Commentator'],
      condition_note: 'condition_note',
      contents_note: ['Old Contents note'],
      creator: ['Old name creator'],
      description: ['description'],
      dimensions: ['dimensions'],
      editor: ['editor'],
      engraver: ['engraver'],
      extent: ['extent'],
      finding_aid_url: ['Old Finding aid url'],
      format_book: ['Old Format'],
      funding_note: ['funding_note'],
      genre: ['genre'],
      iiif_text_direction: 'iiif_text_direction',
      iiif_viewing_hint: 'iiif_viewing_hint',
      illustrator: ['illustrator'],
      latitude: ['latitude'],
      license: ['Creative Commons CC0 1.0 Universal'],
      location: ['location'],
      local_identifier: ['local'],
      longitude: ['longitude'],
      medium: ['medium'],
      named_subject: ['named_subject'],
      normalized_date: ['normalized_date'],
      note: ['note'],
      note_admin: ['Old AdminNote'],
      opac_url: 'opac_url',
      page_layout: ['page_layout'],
      place_of_origin: ['place_of_origin'],
      printmaker: ['Old printmaker'],
      repository: ['repostiory'],
      resource_type: ['resource_type'],
      resp_statement: ['Statement of Responsibility'],
      rights_country: ['rights_country'],
      rights_holder: ['rights_holder'],
      rubricator: ['Old rubricator'],
      subject_geographic: ['Old Subject geographic'],
      subject_temporal: ['Old Subject temporal'],
      subject_cultural_object: ['Old Subject cultural object'],
      subject_domain_topic: ['Old Subject domain topic'],
      subject_topic: ['subject_topic'],
      summary: ['summary'],
      support: ['support'],
      thumbnail_link: 'https://fake.url/iiif/ark%3A%2Fabcde%2F1234567',
      title: ['title'],
      translator: ['Old Translator'],
      uniform_title: ['Old Uniform title'],
      interviewer: ['Old Interviewer'],
      interviewee: ['Old Interviewee'],
      cartographer: ['Old Cartographer'],
      artist: ['Old Artist'],
      recipient: ['Old Recipient'],
      director: ['Old Director'],
      producer: ['Old Producer'],
      content_disclaimer: ['Old Disclaimer'],
      program: ['Old Program'],
      series: ['Old Series'],
      host: ['Old Host'],
      musician: ['Old Musician'],
      printer: ['Old Printer'],
      researcher: ['Old Researcher']
    )
  end

  before do
    allow(ability).to receive(:admin?) { true }
  end

  it 'has author' do
    expect(page).to match(/author/)
  end
  it 'has binding_note' do
    expect(page).to match(/binding_note/)
  end
  it 'has calligrapher' do
    expect(page).to match(/calligrapher/)
  end
  it 'has caption' do
    expect(page).to match(/caption/)
  end
  it 'has citation_source' do
    expect(page).to match(/citation_source/)
  end
  it 'has colophon' do
    expect(page).to match(/colophon/)
  end
  it 'has commentator' do
    expect(page).to match(/commentator/)
  end
  it 'has condition_note' do
    expect(page).to match(/condition_note/)
  end
  it 'has contents_note' do
    expect(page).to match(/contents_note/)
  end
  it 'has creator' do
    expect(page).to match(/creator/)
  end
  it 'has dimesions' do
    expect(page).to match(/dimensions/)
  end
  it 'has editor' do
    expect(page).to match(/editor/)
  end
  it 'has engraver' do
    expect(page).to match(/engraver/)
  end
  it 'has extent' do
    expect(page).to match(/extent/)
  end
  it 'has finding_aid_url' do
    expect(page).to match(/finding_aid_url/)
  end
  it 'has format_book' do
    expect(page).to match(/format_book/)
  end
  it 'has funding_note' do
    expect(page).to match(/funding_note/)
  end
  it 'has genre' do
    expect(page).to match(/genre/)
  end
  it 'has iiif_text_direction' do
    expect(page).to match(/iiif_text_direction/)
  end
  it 'has iiif_viewing_hint' do
    expect(page).to match(/iiif_viewing_hint/)
  end
  it 'has illustrator' do
    expect(page).to match(/illustrator/)
  end
  it 'has latitude' do
    expect(page).to match(/latitude/)
  end
  it 'has license' do
    expect(page).to match(/license/)
  end
  it 'has location' do
    expect(page).to match(/location/)
  end
  it 'has local identifier' do
    expect(page).to match(/local/)
  end
  it 'has longitude' do
    expect(page).to match(/longitude/)
  end
  it 'has medium' do
    expect(page).to match(/medium/)
  end
  it 'has named_subject' do
    expect(page).to match(/named_subject/)
  end
  it 'has normalized_date' do
    expect(page).to match(/normalized_date/)
  end
  it 'has note' do
    expect(page).to match(/note/)
  end
  it 'has note_admin' do
    expect(page).to match(/note_admin/)
  end
  it 'has opac_url' do
    expect(page).to match(/opac_url/)
  end
  it 'has page_layout' do
    expect(page).to match(/page_layout/)
  end
  it 'has place_of_origin' do
    expect(page).to match(/place_of_origin/)
  end
  it 'has printmaker' do
    expect(page).to match(/printmaker/)
  end
  it 'has repo' do
    expect(page).to match(/repository/)
  end
  it 'has resource type' do
    expect(page).to match(/resource_type/)
  end
  it 'has resp_statement' do
    expect(page).to match(/resp_statement/)
  end
  it 'has rights_country' do
    expect(page).to match(/rights_country/)
  end
  it 'has rights_holder' do
    expect(page).to match(/rights_holder/)
  end
  it 'has rubricator' do
    expect(page).to match(/rubricator/)
  end
  it 'has subject_geographic' do
    expect(page).to match(/subject_geographic/)
  end
  it 'has subject_temporal' do
    expect(page).to match(/subject_temporal/)
  end
  it 'has subject_cultural_object' do
    expect(page).to match(/subject_cultural_object/)
  end
  it 'has subject_domain_topic' do
    expect(page).to match(/subject_domain_topic/)
  end
  it 'has subject_topic' do
    expect(page).to match(/subject_topic/)
  end
  it 'has summary' do
    expect(page).to match(/summary/)
  end
  it 'has support' do
    expect(page).to match(/support/)
  end
  it 'has title' do
    expect(page).to match(/title/)
  end
  it 'has translator' do
    expect(page).to match(/translator/)
  end
  it 'has uniform_title' do
    expect(page).to match(/uniform_title/)
  end
  it 'has artist' do
    expect(page).to match(/artist/)
  end
  it 'has cartographer' do
    expect(page).to match(/cartographer/)
  end
  it 'has content_disclaimer' do
    expect(page).to match(/content_disclaimer/)
  end
  it 'has interviewee' do
    expect(page).to match(/interviewee/)
  end
  it 'has interviewer' do
    expect(page).to match(/interviewer/)
  end
  it 'has director' do
    expect(page).to match(/director/)
  end
  it 'has producer' do
    expect(page).to match(/producer/)
  end
  it 'has recipient' do
    expect(page).to match(/recipient/)
  end
  it 'has program' do
    expect(page).to match(/program/)
  end
  it 'has series' do
    expect(page).to match(/series/)
  end
  it 'has host' do
    expect(page).to match(/host/)
  end
  it 'has musician' do
    expect(page).to match(/musician/)
  end
  it 'has printer' do
    expect(page).to match(/printer/)
  end
  it 'has researcher' do
    expect(page).to match(/researcher/)
  end
  # This invokes License renderer from hyrax gem
  # it 'has local_rights_statement' do
  # expect(page).to match(/local_rights_statement/)
  # end
end
