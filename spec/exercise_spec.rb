require_relative 'spec_helper'
require_relative '../lib/exercise'

describe Exercise do
  describe '#initialize' do
    it 'should be false by default' do
      exercise = Exercise.new(['+'], 2, 4, '8')
      value(exercise.correct?).must_equal false
    end

    it 'should raise exception if difficulty less then 1' do
      -> { Exercise.new(['+'], 0, 1, 1, '2') }.must_raise Exception
    end
  end

  describe '#subject?' do
    it 'should return true if subject is present' do
      subjects = %w[foo bar]
      exercise = Exercise.new(subjects, 2, 4, '8')
      value(exercise.subject?(subjects[0])).must_equal true
    end

    it 'should return false if subject is present' do
      subjects = %w[foo bar]
      exercise = Exercise.new(subjects, 2, 4, '8')
      value(exercise.subject?('hi')).must_equal false
    end
  end

  describe '#make_correct' do
    it 'should mark exercise as correct' do
      exercise = Exercise.new(['+'], 2, 4, '8')
      exercise.make_correct!
      value(exercise.correct?).must_equal true
    end
  end

  describe '#<=>' do
    it 'should behave like <=> for @difficulty' do
      ex1 = Exercise.new(['+'], 1, 0, 'a')
      ex2 = Exercise.new(['+'], 2, 0, 'a')
      ex3 = Exercise.new(['+'], 2, 0, 'a')
      value((ex1 <=> ex2) < 0).must_equal true
      value((ex2 <=> ex1) > 0).must_equal true
      value((ex2 <=> ex3) == 0).must_equal true
    end
  end
end
