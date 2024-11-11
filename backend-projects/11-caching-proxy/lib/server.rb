# frozen_string_literal: true

require 'socket'

class Server
  @instance = new

  private_class_method :new

  class << self
    def instance
      @instance
    end
  end

  def start(port, origin)
    server  = TCPServer.new('localhost', port)

    puts "Server started on port: #{port} and forwarding requests to server: #{origin}"

    loop {
      client  = server.accept
      request = client.readpartial(2048)
      puts request
    }
  end
end
