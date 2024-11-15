# frozen_string_literal: true

require 'net/http'

class Client
  attr_reader :base_url

  def initialize(base_url)
    @base_url = base_url
  end

  def request(method, path, headers)
    case method.downcase
    when 'get'
      get(path, headers)
    end
  end

  def get(path, headers)
    uri = URI.join(base_url, path)

    req = Net::HTTP::Get.new(uri)
    req.initialize_http_header(headers)

    res = Net::HTTP.start(
      uri.hostname,
      uri.port,
      use_ssl: uri.scheme == 'https'
    ) do |http|
      http.request(req)
    end

    res.body
  end
end
