require 'relaxdb'
require 'relaxedwiki/document'

class RelaxDB::Document
  def self.acts_as_wiki_document
    include RelaxedWiki::Document
  end
end


