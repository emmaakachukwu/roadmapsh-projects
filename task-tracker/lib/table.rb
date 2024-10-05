# frozen_string_literal: true

class Table
  class << self
    def display(headers, rows)
      puts header_string(headers.values) + row_string(headers.keys, rows)
    end

    private

    ROW_WIDTH = 30

    def header_string(headers)
      string = ''
      last_header = headers.last
      headers.each { |header| string += header.equal?(last_header) ? header : header.ljust(ROW_WIDTH) }
      "#{string}\n\n"
    end

    def row_string(headers, rows)
      string = ''
      last_header = headers.last
      rows.each do |row|
        headers.each do |header|
          row_text = row[header].to_s
          string += header.equal?(last_header) ? row_text : row_text.ljust(ROW_WIDTH)
        end
        string += "\n"
      end
      string
    end
  end
end
