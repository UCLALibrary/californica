# frozen_string_literal: true
# A specialized error that can be used to write actionable logs about failed file characterization.
# Eventually, we might also use this to create a report of corrupt files.
module Californica
  class CorruptFileError < StandardError
    def initialize(file_set_id:, mime_type:)
      @file_set_id = file_set_id
      @mime_type = mime_type
    end

    def ark
      FileSet.find(@file_set_id).parent.ark
    rescue
      "Unknown ark"
    end

    def work_id
      FileSet.find(@file_set_id).parent.id
    rescue
      "Unknown work_id"
    end

    def import_url
      FileSet.find(@file_set_id).import_url
    rescue
      "Unknown import path"
    end

    def message
      "event: unexpected file characterization: ark: #{ark}, work_id: #{work_id}, import_url: #{import_url}, mime_type: #{@mime_type}"
    end
  end
end
