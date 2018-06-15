# frozen_string_literal: true

# Stores exercise data
class Exercise
  attr_reader :difficulty, :answer, :text
  attr_writer :correct

  def initialize(subject, difficulty, answer, text)
    raise 'Difficulty must be 1 or greater' unless difficulty >= 1
    @subject = subject
    @difficulty = difficulty
    @answer = answer
    @text = text
    @correct = correct
  end

  def subject_present?(subject)
    @subject.include?(subject.strip)
  end

  def correct?
    @correct
  end

  def <=>(other)
    @difficulty <=> other.difficulty
  end
end
