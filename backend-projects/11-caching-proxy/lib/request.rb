# frozen_string_literal: true

class Request
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def parse
    method, path = request.lines.first.split

    {
      path: path,
      method: method,
      headers: headers
    }
  end

  private

  def headers
    headers = {}
    request.lines[1..-1].each do |line|
      return headers if line == "\r\n"

      header, value = line.split
      header        = normalize(header)
      headers[header] = value
    end
  end

  def normalize(header)
    header.gsub(':', '').to_sym
  end
end
