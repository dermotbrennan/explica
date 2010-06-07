require 'crack'
require "em-synchrony/em-http"

class Wiktionary
  BASE_URI = 'http://en.wiktionary.org/'
  USER_AGENT = 'Dermot Brennan WebApp: dermot.brennan@gmail.com'

  def self.aget(query, limit = 3)
    params = {:search => query, :limit => limit, :action => 'opensearch', :format => 'json'}
    head = {"User-Agent" => USER_AGENT}
    EventMachine::HttpRequest.new("#{BASE_URI}api.php").aget(:query => params, :head => head)
  end

  def self.parse(http)
    Crack::JSON.parse(http.response)
  end
end