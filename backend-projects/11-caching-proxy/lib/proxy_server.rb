# frozen_string_literal: true

require 'socket'
require_relative 'request'
require_relative 'client'

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

    puts "Server started on port: #{port} and forwarding requests to server: #{origin}"

    loop {
      socket  = server.accept
      request = socket.readpartial(2048)
      puts handle_request(request)
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

    client = Client.new(origin)
    client.request(*parsed_req.values_at(:method, :path, :headers))
  end

end
