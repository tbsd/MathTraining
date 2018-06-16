# frozen_string_literal: true

require_relative 'exercise'
# YamlExerciseReader
module YER
  def self.read_exercises
    data = YAML.load_file('data/exercises.yaml')
    data.map do |ex|
      Exercise.new(ex['subject'], ex['difficulty'], ex['answer'], ex['text'])
    end
  end

  def self.read_user_data
    YAML.load_file('data/user_data.yaml')
  end
end
