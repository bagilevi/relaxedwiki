require 'relaxdb'
require 'relaxedwiki/document'
require 'relaxedwiki/historic_document'
require 'relaxedwiki/changelog_controller'

class RelaxDB::Document
  def self.acts_as_relaxedwiki_document
    include RelaxedWiki::Document
  end
end

