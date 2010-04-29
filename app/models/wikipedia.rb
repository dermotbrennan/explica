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

  def self.download(title)
    url = URI.parse(self.base_uri)
    res = Net::HTTP.start(url.host, url.port) {|http|  http.get("/w/index.php?title=#{title}&action=raw") }
    res.try(:body)
  end
end