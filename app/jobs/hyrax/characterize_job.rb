# frozen_string_literal: true
# Local override of the class at https://github.com/samvera/hyrax/blob/master/app/jobs/characterize_job.rb
# We are overriding this locally so we can improve and customize the error logging.
class Hyrax::CharacterizeJob < Hyrax::ApplicationJob
  queue_as Hyrax.config.ingest_queue_name

  # Characterizes the file at 'filepath' if available, otherwise, pulls a copy from the repository
  # and runs characterization on that file.
  # @param [FileSet] file_set
  # @param [String] file_id identifier for a Hydra::PCDM::File
  # @param [String, NilClass] filepath the cached file within the Hyrax.config.working_path
  def perform(file_set, file_id, filepath = nil)
    raise "#{file_set.class.characterization_proxy} was not found for FileSet #{file_set.id}" unless file_set.characterization_proxy?
    filepath = Hyrax::WorkingDirectory.find_or_retrieve(file_id, file_set.id) unless filepath && File.exist?(filepath)
    Hydra::Works::CharacterizationService.run(file_set.characterization_proxy, filepath)
    Rails.logger.debug "Ran characterization on #{file_set.characterization_proxy.id} (#{file_set.characterization_proxy.mime_type})"
    file_set.characterization_proxy.save!
    file_set.update_index
    file_set.parent&.in_collections&.each(&:update_index)

    # Check that MiniMagick agrees that this is a TIFF
    if Californica::IsValidImage.new(image: filepath).valid?
      # Continue to create derivatives
      CreateDerivativesJob.perform_later(file_set, file_id, filepath)
    else
      # If there is a MiniMagick error, record an error and don't continue to
      # create derivatives for that file
      error = Californica::CorruptFileError.new(file_set_id: file_set.id, mime_type: file_set.characterization_proxy.mime_type)
      Rails.logger.error error.message
    end
  end
end
