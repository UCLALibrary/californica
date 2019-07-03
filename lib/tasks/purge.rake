# frozen_string_literal: true
require 'set'

namespace :californica do
  namespace :purge do
    task orphan_filesets: [:environment] do
      puts "Looking for orphan filesets..."
      FileSet.all.each do |file_set|
        begin
          next unless file_set.member_of.count.zero?
          puts "Deleting orphan fileset #{file_set.id} import_url=#{file_set.import_url}"
          file_set.delete
        rescue => e
          puts "Error deleting #{file_set.id}: #{e.message}"
        end
      end
    end

    task duplicate_filesets: [:environment] do
      puts "Looking for duplicate filesets"
      [Work, ChildWork].each do |record_class|
        record_class.all.each do |record|
          import_urls = Set.new
          duplicates = Set.new
          record.file_sets.each do |fs|
            if import_urls.include?(fs.import_url)
              duplicates << fs
            else
              import_urls << fs.import_url
            end
          end
          duplicates.each do |fs|
            begin
              puts "Detaching duplicate FileSet #{fs.id} from #{record.id}"
              record.members -= [fs]
            rescue => e
              puts "Error detaching #{fs.id} from #{record.id}: #{e.message}"
            end
          end
          record.save
          duplicates.each do |fs|
            if fs.member_of.count.zero?
              begin
                puts "Deleting orphan FileSet #{fs.id} #{fs.import_url}."
                fs.delete
              rescue => e
                puts "Detached #{fs.id} from #{record.id} but error deleting: #{e.message}"
              end
            else
              puts "Detached #{fs.id} from #{record.id} but it is attached to other works and will not be deleted."
            end
          end
        end
      end
    end
  end
end
