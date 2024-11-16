# frozen_string_literal: true

class Response
  attr_reader :body, :code, :message, :http_version

  def initialize(response)
    @body = response.body
    @headers = response.to_hash
    @code = response.code
    @message = response.message
    @http_version = response.http_version
    @response = response
  end

  def normalize
    lines = ["HTTP/#{http_version} #{code} #{message}"]
    @response.each_header { |k, v| lines << "#{k}: #{v}" }
    lines << DELIMITER
    lines << body
    lines.join(DELIMITER)
  end

  private

  DELIMITER = "\r\n"

end
