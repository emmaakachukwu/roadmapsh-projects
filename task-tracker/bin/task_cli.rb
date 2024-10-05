#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative '../lib/task'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: task_cli <command> [<args>]'

  opts.on('-d DESCRIPTION', '--description DESCRIPTION', String, 'Specify optional task description') do |description|
    options[:description] = description
  end

  opts.on('-s STATUS', '--status STATUS', %i[todo in-progress done], "Specify task status (todo, in-progress, done) (default: todo)") do |status|
    options[:status] = status
  end
end.parse!

command = ARGV.first
args = ARGV[1..-1]
task = Task.new

case command
when 'add'
  task.add(args.first, **options)
when 'update'
  task.update(args.first, task: args[1], **options)
when 'delete'
  task.delete(args.first)
end
