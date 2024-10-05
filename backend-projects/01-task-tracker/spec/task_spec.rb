# frozen_string_literal: true

require_relative '../lib/task'
require 'json'

RSpec.describe Task do
  describe '#initialize' do
    it 'sets up the datastore' do
      expect(File).to exist("#{__dir__}/../.tasks.json")
    end

    it 'fetches tasks' do
      task = Task.new
      expect(task.send(:tasks)).to be_an_instance_of(Array)
    end
  end
end
