class Exercise
  attr_reader :difficulty, :answer, :text

  def initialize(difficulty, answer, text, subject = [])
    @subject = subject
    @difficulty = difficulty.to_i
    @answer = answer.to_i
    @text = text.to_s
  end
  
  def subject_present?(subject)
    @subject.include?(subject)
  end
end
