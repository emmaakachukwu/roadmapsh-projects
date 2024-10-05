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

  def update(id, task: nil, description: nil, status: nil)
    task_hash = find_task(id)
    raise "Invalid task ID: #{id}" if task_hash.nil?

    task_hash.merge!({ task:, description:, status:, updatedAt: Time.now }.compact)
    update_file

    puts status.nil? ? "Task updated successfully (ID: #{id})" : "Task marked as #{status} (ID: #{id})"
  end

  def delete(id)
    task_hash = find_task(id)
    raise "Invalid task ID: #{id}" unless task_hash

    # kind of soft deleting the task object
    # so as to not disrupt the auto increment of ID
    # similar to how relational DBs work
    task_hash.replace({})
    update_file

    puts "Task deleted successfully (ID: #{id})"
  end

  private

  attr_accessor :tasks

  def setup_datastore
    File.open(JSON_FILE, 'w') do |f|
      f.write("#{JSON.generate([])}\n")
    end unless File.exist?(JSON_FILE)
  end

  def fetch_tasks
    @tasks ||= JSON.parse(File.read(JSON_FILE), symbolize_names: true)
  end

  def generate_id
    tasks.length + 1
  end

  def update_file
    File.open(JSON_FILE, 'w') do |f|
      f.write("#{JSON.generate(tasks)}\n")
    end
  end

  def find_task(id)
    tasks.find { |t| t[:id] == id.to_i }
  end
end
