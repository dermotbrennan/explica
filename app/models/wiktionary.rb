require 'httparty'

class Wikipedia
  include HTTParty
  format :json
  base_uri 'http://en.wiktionary.org/'
  headers "User-Agent" => 'Dermot Brennan WebApp: dermot.brennan@gmail.com'
  default_params :action => 'opensearch', :format => 'json'

  def self.find(query, limit = 3)
    get('/api.php', :query => {:search => query, :limit => limit})
  end
end