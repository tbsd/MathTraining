# frozen_string_literal: true

# Stores test data
class Test
  def initialize(main_list, additional_list = [])
    @main_list = main_list
    @additional_list = additional_list
    @cur_pos = 0
    @ended = false
  end

  def answer!(answer)
    raise 'Test is over' if @ended
    @main_list[@cur_pos].make_correct! if @main_list[@cur_pos].answer == answer
    next_exercise
    @ended = true if @cur_pos >= @main_list.size
    @main_list[@cur_pos - 1].correct?
  end

  def expected_count
    @main_list.size
  end

  def abort!
    @ended = true
  end

  def current
    @main_list[@cur_pos]
  end

  def past_count
    @cur_pos
  end

  def correct_count
    past = @main_list.first(@cur_pos)
    past.count(&:correct?)
  end

  def mistake_stats
    mistakes = { :+ => 0, :- => 0, :* => 0, :/ => 0 }
    past = @main_list.first(@cur_pos)
    incorrect = past.find_all { |e| !e.correct? }
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
      e.difficulty == @main_list[@cur_pos].difficulty
    end
    unless @main_list[@cur_pos].correct? || add_ex.nil?
      @main_list.insert(@cur_pos + 1, @additional_list.delete_at(add_ex))
    end
    @cur_pos += 1
  end
end
