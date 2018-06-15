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
    @current.correct = true if @current.answer == answer
    @past << @current
    @current = main_list.shift
  end

  def past_count
    @past.size
  end

  def correct_count
    @past.count(&:correct?)
  end

  def mistake_stats
    mistakes = { :+ => 0, :- => 0, :* => 0, :/ => 0 }
    mistakes.each_key do |key|
      mistakes[key] = @past.count do |e|
        !e.correct? && e.subject_present?(key.to_s) 
      end
    end
  end
end
