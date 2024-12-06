# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

module BS
  HOST = '127.0.0.1'
  PORT = 8080
  EXIT_SIGNAL_MSG = '_left the chat_'

  autoload :Server, "bs/server"
  autoload :Client, 'bs/client'
end
