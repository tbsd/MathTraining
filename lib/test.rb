# frozen_string_literal: true

# Stores test data
class Test
  attr_reader :current

  def initialize(main_list, additional_list = [])
    @main_list = main_list
    @additional_list = additional_list
    @past = []
    @current = main_list.shift
    @ended = false
  end

  def answer!(answer)
    raise 'Test is over' if @ended
    @current.make_correct! if @current.answer == answer
    @past << @current
    @current = next_exercise
    @ended = true if @current.nil?
    @past.last.correct?
  end

  def expected_count
    count = @past.size + @main_list.size
    count += 1 unless @current.nil?
    count
  end

  def abort!
    @ended = true
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
      mistakes[key] = incorrect.count { |e| e.subject?(key.to_s) }
    end
  end

  def ended?
    @ended
  end

  private

  def next_exercise
    add_ex = @additional_list.find_index do |e|
      e.difficulty == @current.difficulty
    end
    if @current.correct? || add_ex.nil?
      @main_list.shift
    else
      @additional_list.delete_at(add_ex)
    end
  end
end
