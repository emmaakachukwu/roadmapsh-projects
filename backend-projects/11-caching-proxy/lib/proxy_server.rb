# frozen_string_literal: true

require 'socket'
require_relative 'request'
require_relative 'client'
require_relative 'response'

class ProxyServer
  @instance = nil

  attr_reader :port, :origin

  private_class_method :new

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
      output = handle_response(response)

      socket.write(output)
      socket.close
    }
  end

  private

  def initialize(port, origin)
    @port   = port
    @origin = origin
  end

  def handle_request(req)
    parsed_req = Request.new(req).parse

    puts "Forwarding #{parsed_req.fetch(:method)} request for path: "\
         "#{parsed_req.fetch(:path)} "\
         "to: #{URI.join(origin, parsed_req.fetch(:path))}"

    client = Client.new(origin)
    client.request(*parsed_req.values_at(:method, :path, :headers))
  end

  def handle_response(res)
    puts "HTTP Response Status Code: #{res.code}\n\n"
    Response.new(res).normalize
  end

end
