module RelaxedWiki

  # Will be included by a model when acts_as_relaxedwiki_document is called.
  # That model must extend RelaxDB::Document
  module Document
  
    def self.included(base)
      base.class_eval <<-EOS, __FILE__, __LINE__ + 1
        property :wiki_content
        before_save(lambda do |doc|
          doc.generate_or_parse_wiki_content
          doc.create_historic_document
	      end)
      EOS
    end
  
    def generate_or_parse_wiki_content
      if @wiki_change && @wiki_change[:type] == 'markup'
        if self.respond_to?(:parse_wiki_content) then
          # When user edited the markup
          self.parse_wiki_content
        end
      else
        if self.respond_to?(:generate_wiki_content) then
          # When user edited by the form
          self.generate_wiki_content
        end
      end
    end

    # Called by RelaxDB::Document.set_attributes
    def wiki_change=(params)
      @wiki_change = params
    end

    def create_historic_document
      if @wiki_change
        RelaxedWiki::HistoricDocument.create_from_edit(self, @wiki_change)
      end
    end

    def versions
      RelaxedWiki::HistoricDocument.by_document_id_and_created_at(
        :startkey => [self.id],
        :endkey   => [self.id, {}],
        :reduce     => false )
    end

    def version_by_time(timestamp)
      RelaxedWiki::HistoricDocument.by_document_id_and_created_at(
        :key     => [self.id, timestamp],
        :reduce  => false )[0]
    end

  end

end
