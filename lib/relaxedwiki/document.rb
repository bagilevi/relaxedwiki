module RelaxedWiki

  # Will be included by a model when acts_as_wiki_document is called.
  # That model must extend RelaxDB::Document
  module Document
  
    def self.included(base)
      base.class_eval <<-EOS, __FILE__, __LINE__ + 1
        property :wiki_content
          before_save(lambda do |doc|
          if !doc.respond_to?(:wiki_content) || doc.wiki_content.nil? || doc.wiki_content.empty?
            if doc.respond_to?(:generate_wiki_content) then
              doc.generate_wiki_content
            end
          else
            if doc.respond_to?(:parse_wiki_content) then
              doc.parse_wiki_content
            end
          end
	      end)
      EOS
    end
  
    def update_wiki_content(params)

      # 1. Create new history entry
      require File.join(File.dirname(__FILE__), 'historic_document')
      RelaxedWiki::HistoricDocument.create_from_edit(self, params[:change])

      # 2. Update content in the document
      self.wiki_content = params[:wiki_content]
      if self.respond_to?(:parse_wiki_content) then
        self.parse_wiki_content
      end
      self.save!

    end
  end

end
