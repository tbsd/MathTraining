# Stores exercise data
class Exercise
  attr_reader :difficulty, :answer, :text

  def initialize(hash)
    @subject = hash['subject']
    @difficulty = hash['difficulty']
    @answer = hash['answer']
    @text = hash['text']
  end

  def subject_present?(subject)
    @subject.include?(subject.strip)
  end
end
