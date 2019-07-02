# frozen_string_literal: true
namespace :californica do
  desc 'Audit records listed in csv.'
  task audit: [:environment] do
    unless CSV_FILE
      puts "Specify import parameters like this: CSV_FILE=/path/to/file.csv bundle exec rails californica:audit"
      next
    end
    puts "Auditing works listed in #{CSV_FILE}"
    file = File.open(CSV_FILE)
    errors = []
    CalifornicaCsvAuditor.new(file: file, error_stream: errors).audit
    file.close
    puts errors.join("\n")
  end
end
