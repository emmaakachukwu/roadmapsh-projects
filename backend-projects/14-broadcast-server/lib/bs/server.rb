# frozen_string_literal: true

require 'socket'

module BS
  class Server
    class << self
      def start
        server = TCPServer.new(HOST, PORT)

        puts "Server started on #{HOST}:#{PORT}"

        loop {
          Thread.start(server.accept) do |client|
            handle_client(client)
          end
        }
      rescue Interrupt
        puts 'Shutting down gracefully..'
        server.close
      end

      private

      attr_accessor :clients

      def save_client(client)
        clients ||= {}
        clients[client.peeraddr[1]] = client
      end

      def handle_client(client)
        puts "Client connected from port: #{client.peeraddr[1]}"
        save_client(client)
        while line = client.gets
          line.strip!
          puts "User##{client.peeraddr[1]}: #{line}"
          client.puts "You: #{line}"
        end
      end
    end
  end
end
