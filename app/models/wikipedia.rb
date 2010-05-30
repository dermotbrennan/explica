require 'uri'
require 'cgi'
require 'httparty'

class Wikipedia
  include HTTParty
  format :json
  base_uri 'http://en.wikipedia.org/w'
  headers "User-Agent" => 'Dermot Brennan WebApp: dermot.brennan@gmail.com'
  default_params :action => 'opensearch', :format => 'json'
  IMAGE_WIDTH = 100

  def self.find(query, limit = 3)
    get('/api.php', :query => {:search => query, :limit => limit})
  end

#  def self.download(title, options = {})
#    default_options = {:follow_redirects => false, :remove_excess => true}
#    options = default_options.merge(options)
#
#    url = URI.parse(self.base_uri)
#    res = Net::HTTP.start(url.host, url.port) {|http|  http.get("/w/index.php?title=#{URI.escape(title)}&action=raw") }
#    body = res.try(:body)
#
#    if options[:follow_redirects]
#      redirect_match = body.match(/^#REDIRECT ?\[\[(.+)\]\]/i)
#      if redirect_match && redirect_match.to_a[1]
#        title, body = self.download(redirect_match.to_a[1], :follow_redirects => true)
#      end
#    end
#
#    Rails.logger.debug body.inspect
#    if options[:remove_excess]
#      body.gsub!(/\[\[[a-z]{2,3}:.+\]\]/, '')
#    end
#
#    return title, body
#  end

  def self.download(title)
#    url = URI.parse(self.base_uri)

#    res = Net::HTTP.start(url.host, url.port) {|http|  http.get("/w/api.php?action=parse&title=#{URI.escape(title)}&redirect=true&prop=text|displaytitle") }
#    body = res.try(:body)
    res = get('/api.php', :query => {:action => 'parse', :page => URI.escape(title), :prop => 'text|displaytitle', :redirects => true})
    #  ['query']['pages'].values[0]['imageinfo'][0]['thumburl']
    body = res['parse']['text']['*']
    article_title = res['parse']['displaytitle']
    #Rails.logger.debug res.inspect

    
    return article_title, body
  end

  def self.article_url(title)
    self.base_uri + "iki/#{URI.escape(title)}"
  end

  def self.find_image_url(image_name, thumb_width = IMAGE_WIDTH)
    puts "Looking for image #{image_name}"
    #api.php?action=query&titles=File:Binubulauan3092.jpg&prop=imageinfo&iilimit=1&iiprop=url
    begin
      get('/api.php', :query => {:action => 'query', :titles => "File:#{image_name}", :prop => 'imageinfo',
        :iilimit => 1, :iiprop => 'url', :iiurlwidth => thumb_width})['query']['pages'].values[0]['imageinfo'][0]['thumburl']
    rescue NoMethodError => e
      Rails.logger.debug e.to_s
      return '/images/no-image.png'
    end
  end
end