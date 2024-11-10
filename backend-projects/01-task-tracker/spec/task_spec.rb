# frozen_string_literal: true

require_relative '../lib/task'
require 'json'

RSpec.describe Task do
  before(:all) do
    @json_file = "#{__dir__}/../.tasks.json"
  end

  after(:each) do
    File.delete(@json_file) if File.exist?(@json_file)
  end

  subject { described_class.new }

  describe '#initialize' do
    it 'sets up the datastore' do
      subject
      expect(File).to exist(@json_file)
    end

    it 'fetches tasks' do
      expect(subject.send(:tasks)).to be_an_instance_of(Array)
    end
  end

  describe '#add' do
    let!(:task_count) { subject.send(:tasks).count }

    before do
      subject.add(
        'Say hello to the world',
        description: "We're saying hello world"
      )
    end

    it 'increments task list count by 1' do
      expect(subject.send(:tasks).count).to eq(task_count + 1)
    end

    it 'adds the task details as specified' do
      expect(
        subject.send(:tasks).last.slice(:id, :task, :description, :status)).to eq(
        id: task_count + 1,
        task: 'Say hello to the world',
        description: "We're saying hello world",
        status: :todo
      )
    end
  end

  describe '#update' do
    before do
      subject.add(
        'Say hello to the world',
        description: "We're saying hello world"
      )
    end

    it 'updates task' do
      subject.update(
        1,
        task: 'Say hello to roadmap',
        description: "We're saying hello roadmap"
      )
      expect(
        subject.send(:find_task, 1).slice(:id, :task, :description, :status)).to eq(
        id: 1,
        task: 'Say hello to roadmap',
        description: "We're saying hello roadmap",
        status: :todo
      )
    end
  end

  describe '#delete' do
    before do
      subject.add(
        'Say hello to the world',
        description: "We're saying hello world"
      )
    end

    it 'deletes task' do
      subject.delete(1)
      expect(subject.send(:tasks)).to eq([{}])
    end

    it 'raises correct error on invalid task ID' do
      expect { subject.delete(2) }.to raise_error(RuntimeError, 'Invalid task ID: 2')
    end
  end
end
