# frozen_string_literal: true
namespace :derivatives do
  desc "Regenerate derivatives for all works"
  task regenerate_all: :environment do
    Hyrax.config.curation_concerns.each do |work_type|
      total = 0

      work_type.all.each do |work|
        regenerate_derivatives(work)
        total += 1
      end

      puts "Regenerated derivatives for #{total} #{work_type} works(s)"
    end
  end

  def regenerate_derivatives(work)
    work.file_sets.each do |fs|
      puts " processing FileSet #{fs.id}"
      asset_path = fs.original_file.uri.to_s
      asset_path = asset_path[asset_path.index(fs.id.to_s)..-1]
      CreateDerivativesJob.perform_later(fs, asset_path)
    end
  end
end
