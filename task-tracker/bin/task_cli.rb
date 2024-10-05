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
end.parse!

command = ARGV.first
todo = ARGV.last
task = Task.new

case command
when 'add'
  task.add(todo, **options)
end
