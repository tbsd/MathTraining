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
    raise '@cuttent is nil' if @current.nil?
    @current.correct = true if @current.answer == answer
    @past << @current
    @current = next_exercise
    @past.last.correct?
  end

  def total_count
    @past.size + @main_list.size
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

  private

  def next_exercise
    add_ex = @additional.find { |e| e.diffficulty == @current.difficulty }
    if @current.correct? || add_ex.nil?
      @main_list.shift
    else
      @additional.delete(new_ex)
    end
  end
end
