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
  
  end

end
