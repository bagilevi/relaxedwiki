class WikiController < ApplicationController

  before_filter :load_document_by_slug

  def show
  end

  def edit
  end
  
  def update
    params[:document][:change][:created_by] = current_user.id
    @document.set_attributes(params)
    redirect_to wiki_url_for(@document)
  end

  def changelog
    @entries = RelaxedWiki::HistoricDocument.by_document_id_and_created_at(
      :startkey => [@document.id],
      :endkey   => [@document.id, {}],
      :reduce     => false )
  end
  
  def version
    @historic_document = RelaxedWiki::HistoricDocument.by_document_id_and_created_at(
      :key => [@document.id, params[:time].gsub(/\-/, '/') + ' +0000'],
      :reduce     => false )[0]
  end
  
  private 
  
  def load_document_by_slug
    result = RelaxDB.view "Id_by_class_and_slug", 
      :key => [params[:class].classify, params[:slug]],
      :reduce     => false
    raise "404 Not Found" if result[0].nil?
    @document = result[0]
  end


end
