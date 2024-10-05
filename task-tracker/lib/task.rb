# frozen_string_literal: true

require 'json'

class Task
  JSON_FILE = "#{__dir__}/../.tasks.json"

  def initialize
    setup_datastore
    fetch_tasks
  end

  def add(task, description: nil, status: :todo)
    time = Time.now
    id = generate_id
    object = {
      id:,
      task:,
      description:,
      status:,
      createdAt: time,
      updatedAt: time
    }
    tasks << object
    update_file

    puts "Task added successfully (ID: #{id})"
  end

  private

  attr_accessor :tasks

  def setup_datastore
    File.open(JSON_FILE, 'w') do |f|
      f.write("#{JSON.generate([])}\n")
    end unless File.exist?(JSON_FILE)
  end

  def fetch_tasks
    @tasks ||= JSON.parse(File.read(JSON_FILE))
  end

  def generate_id
    tasks.length + 1
  end

  def update_file
    File.open(JSON_FILE, 'w') do |f|
      f.write("#{JSON.generate(tasks)}\n")
    end
  end
end
