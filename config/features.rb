# frozen_string_literal: true

# Put the system into read-only mode. Deposits, edits, approvals and anything that makes a change to the data will be disabled. This will create a safe window during which backups can be performed.

Flipflop.configure do
  feature :read_only,
          default: false,
          description: "Put the system into read-only mode disabling changes and uploads. Do not close this session before re-enabling read/write -- you will not be able to login."

  feature :cache_manifests,
          default: true,
          description: "Cache IIIF manifests on the filesystem. Cached manifests will be invalidated whenever a document is reindexed to solr."

  feature :use_manifest_store,
          default: false,
          description: "Load IIIF manifests from the external manifest-store service when possible."
end
