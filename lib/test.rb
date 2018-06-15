# frozen_string_literal: true

# Stores test data
class Test
  def initialize(main_list, additional_list)
    @main_list = main_list
    @additional_list = additional_list
    @past = []
    @current = main_list.shift
  end

  def answer!(answer)
    result = @current.correct = true if @current.answer == answer
    @past << @current
    @current = if @current.correct? || @additional_list.empty?
                 main_list.shift
               else
                 @additional_list.shift
               end
    result
  end

  def past_count
    @past.size
  end

  def correct_count
    @past.count(&:correct?)
  end

  def mistake_stats
    mistakes = { :+ => 0, :- => 0, :* => 0, :/ => 0 }
    incorrect = @past.find_all { |e| !e.correct? }
    mistakes.each_key do |key|
      mistakes[key] = incorrect.count { |e| e.subject_present?(key.to_s) }
    end
  end
end
