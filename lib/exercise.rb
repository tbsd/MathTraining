# frozen_string_literal: true

# Stores exercise data
class Exercise
  attr_reader :difficulty, :answer, :text
  attr_accessor :correct
  def initialize(hash)
    @subject = hash['subject']
    @difficulty = hash['difficulty']
    @answer = hash['answer']
    @text = hash['text']
    @correct = false
  end

  def subject_present?(subject)
    @subject.include?(subject.strip)
  end
end
