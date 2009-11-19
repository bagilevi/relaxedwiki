require 'relaxdb'
require 'relaxedwiki'
require 'relaxedwiki/document'
require 'relaxedwiki/historic_document'
require 'relaxedwiki/changelog_controller'

class RelaxDB::Document
  def self.acts_as_relaxedwiki_document
    include RelaxedWiki::Document
  end
end

class ApplicationController
  def wiki_url_for(document, action = :show)
    RelaxedWiki.wiki_url_for(document, action)
  end
end

