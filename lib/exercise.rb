# frozen_string_literal: true

# Stores exercise data
class Exercise
  include Comparable
  attr_reader :difficulty, :answer, :text

  def initialize(subject, difficulty, answer, text)
    raise 'Difficulty must be 1 or greater' unless difficulty >= 1
    @subject = subject
    @difficulty = difficulty
    @answer = answer
    @text = text
    @correct = false
  end

  def subject?(subject)
    @subject.include?(subject.strip)
  end

  def make_correct!
    @correct = true
  end

  def correct?
    @correct
  end

  def <=>(other)
    @difficulty <=> other.difficulty
  end
end
