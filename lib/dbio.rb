# frozen_string_literal: true

require 'yaml'
require_relative 'exercise'
require_relative 'test'

# Database input/output
module DBIO
  def self.read_exercises
    data = YAML.load_file('data/exercises.yaml')
    data.map do |ex|
      Exercise.new(ex['subject'], ex['difficulty'], ex['answer'], ex['text'])
    end
  end

  def self.read_user_data
    path = 'data/user_data.yaml'
    if File.exist?(path)
      YAML.load_file(path)
    else
      false
    end
  end

  def self.save_user_data(data)
    File.open('data/user_data.yaml', 'w') { |f| f.write(data.to_yaml) }
  end
end
