# frozen_string_literal: true
FactoryBot.define do
  factory :csv_row do
    sequence(:row_number, &:to_s)
    job_id { "23452" }
    csv_import_id { "193453" }
    status { "complete" }
    error_messages { "here is your error" }
    metadata do
      {
        "Project Name" => "Ethiopic Manuscripts",
        "Item ARK" => "21198/zz001pz6jq",
        "Parent ARK" => "21198/zz001pz6h6",
        "Object Type" => "Page",
        "File Name" => "mss_page2.png",
        "Item Sequence" => "2",
        "Type.typeOfResource" => "text",
        "Type.genre" => nil,
        "Rights.copyrightStatus" => "pd",
        "Rights.servicesContact" => nil,
        "Language" => "gez",
        "Name.repository" => nil,
        "AltIdentifier.local" => "Ms. 50_#r or #v?",
        "Title" => "Image 2",
        "AltTitle.other" => "መርበብተ ሰሎሞን|~|ጸሎተ ሱስንዮስ",
        "AltTitle.translated" => "Prayer of Susneyos|~|Prayer of King Solomon for Catching of Demons",
        "AltTitle.uniform" => "Magical prayers",
        "Place of origin" => "Ethiopia",
        "Date.creation" => "18th c.",
        "Date.normalized" => "1700/1799",
        "Format.extent" => "1 image",
        "Format.dimensions" => nil,
        "Support" => "Vellum",
        "Relation.rectoVerso" => nil,
        "Description.note" => nil,
        "Description.history" => nil,
        "Description.condition" => nil,
        "Coverage.temporal" => nil,
        "Description.collation" => nil,
        "Description.binding" => nil,
        "Description.tableOfContents" => nil,
        "Description.contents" => nil,
        "Description.abstract" => nil
      }.to_json
    end
  end
end
