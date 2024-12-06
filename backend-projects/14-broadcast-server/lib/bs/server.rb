# frozen_string_literal: true

require 'socket'

module BS
  class Server
    TCPSocket.class_eval do
      # take advantage of the unique port number being returned as a username
      def user
        self.peeraddr[1]
      end
    end

    def initialize
      @server = TCPServer.new(HOST, PORT)
      @clients = {}
    end

    def start
      puts "Server started and listening on: #{HOST}:#{PORT}"

      loop do
        @recieving_thread = Thread.start(server.accept) do |client|
          puts "Client connected: ##{client.user}"
          save_client(client)
          handle_client(client)
        end
      end
    rescue Interrupt
      shutdown
    end

    private

    attr_reader :server
    attr_accessor :clients

    def handle_client(client)
      return if client.closed?

      while line = client.gets
        line.strip!
        drop_client(client) if line == EXIT_SIGNAL_MSG
        broadcast_message_from_client(line, client)
      end
    end

    def save_client(client)
      clients[client.user] = client
    end

    def broadcast_message_from_client(message, source_client)
      puts "User##{source_client.user}: #{message}"

      clients.each do |user, client|
        if client.eql? source_client
          source_client.puts "You: #{message}"
        else
          client.puts "##{source_client.user}: #{message}"
        end
      end
    end

    def broadcast_message_from_server(message)
      clients.each_value do |client|
        client.puts message
      end
    end

    def shutdown
      puts 'Gracefully shutting down server..'

      broadcast_message_from_server("Server is shutting down..")
      broadcast_message_from_server(EXIT_SIGNAL_MSG)
      server.close unless server.closed?
      @recieving_thread.kill
    end

    def drop_client(client)
      clients.delete(client.user)
    end
  end
end
