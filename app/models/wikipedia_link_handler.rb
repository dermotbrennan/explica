require 'uri'

class WikipediaLinkHandler < WikiCloth::WikiLinkHandler

  def url_for(page)
    Wikipedia.article_url(page)
  end

  def link_attributes_for(page)
     { :href => url_for(page), :target => '_blank' }
  end

  def wiki_image(resource,options)
    # interpolate resource into a real image url
    resource = "/images/ajax-loader.gif\" rel=\"/wikimedias/#{resource}"
    options << "#{Wikipedia::IMAGE_WIDTH}px"
    super(resource,options)
  end
end