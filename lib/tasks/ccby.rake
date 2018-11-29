namespace :ccby do
  desc "Add CCBY license to all records"
  task add_license: :environment do
    works = Work.all
    works.each do |individual_work|
      individual_work.license = ["https://creativecommons.org/licenses/by/4.0/"]
      individual_work.save
    end
  end
end
