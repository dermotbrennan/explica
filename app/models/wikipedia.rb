require 'uri'
require 'cgi'
require 'crack'
require "em-synchrony/em-http"

class Wikipedia
  BASE_URI = 'http://en.wikipedia.org/w'
  USER_AGENT = 'Dermot Brennan WebApp: dermot.brennan@gmail.com'
  IMAGE_WIDTH = 100

  def self.aget(title)
    #    res = Net::HTTP.start(url.host, url.port) {|http|  http.get("/w/api.php?action=parse&title=#{URI.escape(title)}&redirect=true&prop=text|displaytitle") }
    #res = get('/api.php', :query => {:action => 'parse', :page => URI.escape(title), :prop => 'text|displaytitle', :redirects => true})
    params = {:action => 'parse', :page => URI.escape(title), :prop => 'text|displaytitle', :redirects => true, :format => 'json'}
    head = {"User-Agent" => USER_AGENT}
    EventMachine::HttpRequest.new("http://en.wikipedia.org/w/api.php").aget(:query => params, :head => head)
  end

  def self.parse(http)
#    url = URI.parse(self.base_uri)

#    body = res.try(:body)
    res = Crack::JSON.parse(http.response)
    #  ['query']['pages'].values[0]['imageinfo'][0]['thumburl']
    body = res['parse']['text']['*']
    article_title = res['parse']['displaytitle']
    #Rails.logger.debug res.inspect
    
    return article_title, body
  end

  def self.article_url(title)
    BASE_URI + "iki/#{URI.escape(title)}"
  end
end