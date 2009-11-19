module WikiHelper

  def wiki_bar(document, current_page = :view)
    [ [:view,        "View",        wiki_url_for(document)],
      [:edit,        "Edit",        wiki_url_for(document, :edit)],
      [:changelog,   "Changelog",   wiki_url_for(document, :changelog)]
    ].map do |item|
      if (current_page == item[0])
        '<strong>' + h(item[1]) + '</strong>' unless item[0] == :view
      else
        link_to(item[1], item[2])
      end
    end.compact.join(" | ")
  end

  def wiki_edit_bar(document)
    link_to "Edit", wiki_url_for(document, :edit)
  end

  def wiki_version_path(document, historic_document)
    formatted_time = historic_document.created_at.to_json.gsub(/^"([^\\"]+)"*$/, '\1').gsub(/ \+0000/, '').gsub(/\//, '-')
    wiki_url_for(document, "versions/#{formatted_time}")
  end
  
  def wiki_hybrid_form(document)
    type = document.class.name.underscore
    
    concat link_to "Normal edit", "#", :onclick => "$('#wiki_markup_fields').hide(); $('#wiki_normal_fields').show(); $('#document_change_type').val('form'); return false;"
    concat " "
    concat link_to "Markup edit", "#", :onclick => "$('#wiki_normal_fields').hide(); $('#wiki_markup_fields').show(); $('#document_change_type').val('markup'); return false;"

    concat '<div id="wiki_normal_fields">'
      yield
    concat '</div>'
    concat '<div id="wiki_markup_fields" style="display: none;">'
      concat hidden_field_tag "id", h(document.id)
      concat text_area_tag "#{type}[wiki_content]", document.wiki_content, :cols => 80, :rows => 30
      concat '</div>'
    concat '<div id="wiki_change_fields">'
      concat hidden_field_tag "#{type}[wiki_change][type]", "form", :id => "document_change_type"
      concat label_tag "document_change_message", "Describe your change: "
      concat text_field_tag "#{type}[wiki_change][message]", nil, :id => "document_change_message", :size => 40
      concat check_box_tag "#{type}[wiki_change][is_minor]", '1', false, :id => "document_change_is_minor"
      concat label_tag "document_change_is_minor", "minor change"
    concat '</div>'
  end


  def wiki_url_for(document, action = :show)
    RelaxedWiki.wiki_url_for(document, action)
  end

end
