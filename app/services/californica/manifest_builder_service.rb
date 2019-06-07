# frozen_string_literal: true
module Californica
  class ManifestBuilderService
    def initialize(curation_concern:)
      @curation_concern = curation_concern
      @child_works = @curation_concern.ordered_members.to_a.select { |member| member.class == ChildWork || member.class == Work }
      @file_sets = @curation_concern.ordered_members.to_a.select { |member| member.class == FileSet }
    end

    def sets
      sets = if @child_works.length >= 1
               @child_works.each(&:file_sets) + @file_sets.each(&:files)
             else
               @file_sets.each(&:files)
             end
      sets
    end
  end
end
