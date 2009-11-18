module RelaxedWiki

  # A version of a document.
  #
  # When someone changes a document, a new version is created with the new
  # content and the main document is updated, too.

  class HistoricDocument < RelaxDB::Document

    property :document_id      # The ID of the main CouchDB document,
                               # to which this is a version.

    property :wiki_content     # The content, as of this version.

    property :message          # What changes were made compared to the
                               # previous version, entered by user.

    property :is_minor         # true/false: Is it just a small typo or
                               # formatting fix or other minor edit.

    property :created_by       # Who modified the wiki doc.

    property :created_at       # When did this modification happen.
                               # Set automatically by RelaxDB.

    view_by :document_id, :created_at   # For getting the history for a doc.

    def self.create_from_edit(document, change_params)
      params = {  :document_id  => document.id,
                  :wiki_content => document.wiki_content,
                  :message      => change_params[:message],
                  :is_minor     => change_params[:is_minor] ? true : false,
                  :created_by   => change_params[:created_by]  }
      self.new(params).save!
    end

  end

end
