# frozen_string_literal: true

require 'socket'
require_relative 'request'
require_relative 'client'
require_relative 'response'
require_relative 'cache'

class ProxyServer
  @instance = nil

  attr_reader :port, :origin, :cache

  private_class_method :new

  CACHE_EXPIRES_IN = 300

  class << self
    def instance(port, origin)
      @instance ||= new(port, origin)
    end
  end

  def start
    server  = TCPServer.new('127.0.0.1', port)

    puts "Proxy server started on port: #{port} and forwarding requests to server: #{origin}"

    loop {
      socket  = server.accept
      request = socket.readpartial(2048)

      response = handle_request(request)

      socket.write(response)
      socket.close
    }
  end

  private

  def initialize(port, origin)
    @port   = port
    @origin = origin
    @cache = Cache.new
  end

  def handle_request(request)
    parsed_req = Request.new(request).parse
    url = url_string(parsed_req[:path])
    cached_value = cache.read(url)

    if cached_value
      puts "#{url} is cached; retrieving..\n\n"
      return cached_value
    end

    puts "Forwarding #{parsed_req[:method]} request for path: "\
         "#{parsed_req[:path]} "\
         "to: #{url}"

    client = Client.new(origin)
    response = client.request(*parsed_req.values_at(:method, :path, :headers))
    output = handle_response(response)

    cache_response(url, output)

    output
  end

  def handle_response(response)
    puts "HTTP Response Status Code: #{response.code}\n\n"
    Response.new(response).normalize
  end

  def cache_response(key, response_string)
    cache.write(key, response_string, expires_in: CACHE_EXPIRES_IN)
  end

  def url_string(path)
    URI.join(origin, path).to_s
  end

end
