# frozen_string_literal: true

require 'socket'

module BS
  class Client
    class << self
      def connect
        server = TCPSocket.new(HOST, PORT)
        puts "Connected to server on port #{PORT}"

        loop {
          msg = STDIN.gets.chomp
          server.puts msg
          puts server.gets
        }
      end
    end
  end
end
