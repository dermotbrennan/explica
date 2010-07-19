require 'net/http'

module UrlGrabbing
  def grab_url_contents(url)
    url = "http://" + url unless url =~ /^https?:\/\//
    resp = fetch(url)
    body = resp.body
    Rails.logger.debug "test"
    Rails.logger.debug resp.inspect
    # filter response
    body = body.force_encoding("UTF-8")
    Sanitize.clean(body, :remove_contents => ['script', 'style']).gsub(/(\n+\s*)+/im, "\n")
#    body.gsub(/<style.*<\/style>/im, '').
#      gsub(/<script(^<)*<\/script>/im, '').
#      gsub(/(\n+\s*)+/im, "\n").
#      gsub(/<\/?[^>]*>/, " ").
#      strip
  end

  def fetch(uri_str, limit = 10)
      # You should choose better exception.
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0

      response = Net::HTTP.get_response(URI.parse(uri_str))
      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then fetch(response['location'], limit - 1)
      else
        response.error!
      end
    end
end