require 'uri'
require 'httparty'

class Wikipedia
  include HTTParty
  format :json
  base_uri 'http://en.wikipedia.org/w'
  headers "User-Agent" => 'Dermot Brennan WebApp: dermot.brennan@gmail.com'
  default_params :action => 'opensearch', :format => 'json'

  def self.find(query, limit = 3)
    get('/api.php', :query => {:search => query, :limit => limit})
  end

  def self.download(title, options = {:follow_redirects => false})
    url = URI.parse(self.base_uri)
    res = Net::HTTP.start(url.host, url.port) {|http|  http.get("/w/index.php?title=#{URI.escape(title)}&action=raw") }
    body = res.try(:body)

    if options[:follow_redirects]
      redirect_match = body.match(/^#REDIRECT ?\[\[(.+)\]\]/i)
      if redirect_match && redirect_match.to_a[1]
        title, body = self.download(redirect_match.to_a[1], :follow_redirects => true)
      end
    end

    return title, body
  end

  def self.article_url(title)
    self.base_uri + "/#{URI.escape(title)}"
  end
end