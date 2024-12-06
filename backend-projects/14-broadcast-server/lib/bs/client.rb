# frozen_string_literal: true

require 'socket'

module BS
  class Client
    def initialize
      @server = TCPSocket.new(HOST, PORT)
    end

    def connect
      puts "Connected to server: #{HOST}:#{PORT}"

      recieve
      message
    end

    private

    attr_reader :server

    def message
      loop do
        msg = STDIN.gets.chomp
        server.puts msg  unless msg.to_s.empty?
      end
    rescue Interrupt
      shutdown
    end

    def recieve
      @recieving_thread = Thread.new do
        loop do
          msg = server.gets
          next if msg.to_s.empty?

          msg.strip!
          shutdown(from_server: true) if msg == EXIT_SIGNAL_MSG

          puts msg
        end
      end
    end

    def shutdown(from_server: false)
      puts 'Gracefully shutting down client..'

      @recieving_thread.kill unless from_server
      server.puts EXIT_SIGNAL_MSG
      server.close
      abort if from_server
    end
  end
end
