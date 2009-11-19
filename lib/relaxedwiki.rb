module RelaxedWiki

  def self.wiki_url_for(document, action = :show)
    "/#{document.class.name.underscore.pluralize}/#{document.slug}" + (action == :show ? '' : "/" + action.to_s)
  end

end

