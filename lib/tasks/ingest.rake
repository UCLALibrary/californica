# frozen_string_literal: true

namespace :californica do
  namespace :ingest do
    desc 'Ingest an item from MODS XML'
    task :mods, [:filename] => [:environment] do |_task, args|
      parser = ModsXmlParser.for(file: File.open(args[:filename]))

      Darlingtonia::Importer.new(parser: parser).import if parser.validate
    end
  end
end
