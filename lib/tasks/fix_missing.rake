# frozen_string_literal: true

namespace :californica do
  namespace :fix_missing do
    task master_file_path: [:environment] do
      puts "BEFORE: #{Work.where(master_file_path: nil).count} Works, #{ChildWork.where(master_file_path: nil).count} ChildWorks have no master_file_path"

      n = FileSet.count
      FileSet.all.each_with_index do |fs, i|
        print "#{i} / #{n}\r"
        $stdout.flush

        next unless fs.import_url
        computed_path = fs.import_url.match(/Masters\/dlmasters\/.*$/).to_s
        next if computed_path.empty?
        fs.member_of.each do |parent|
          parent.master_file_path ||= computed_path
          parent.save if parent.changed?
        end
      end

      puts "AFTER: #{Work.where(master_file_path: nil).count} Works, #{ChildWork.where(master_file_path: nil).count} ChildWorks have no master_file_path"
    end
  end
end
