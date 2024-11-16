# frozen_string_literal: true

require 'fileutils'
require 'digest'
require 'json'
require 'time'

class Cache
  STORAGE_PATH = "#{__dir__}/../storage/cache"

  def initialize
    FileUtils.mkdir_p(STORAGE_PATH)
  end

  def exist?(key)
    File.exist?(cache_path(key))
  end

  def read(key)
    file_path = cache_path(key)
    return nil unless File.exist?(file_path)

    data = JSON.parse(File.read(file_path), symbolize_names: true)
    expires_at = data.fetch(:expires_at)
    return nil if expires_at && expired?(expires_at)

    data[:value]
  rescue JSON::ParserError, KeyError
    nil
  end

  def write(key, value, expires_in: nil)
    file_path = cache_path(key)
    data = {
      value: value,
      expires_at: expires_in ? Time.now + expires_in : nil
    }

    File.write(file_path, JSON.generate(data))
  end

  def expired?(expires_at)
    Time.now > Time.parse(expires_at)
  end

  def clear
    FileUtils.rm_rf("#{STORAGE_PATH}/.", secure: true)
  end

  private

  def cache_path(key)
    File.join(STORAGE_PATH, Digest::MD5.hexdigest(key))
  end

end
