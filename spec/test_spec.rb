require_relative 'spec_helper'
require_relative '../lib/test'

describe Test do
  describe '#answer!' do
    it 'should return true on correct answer' do
      answer = 32_767
      test = Test.new([Exercise.new(['+'], 1, answer, 'a')])
      value(test.answer!(answer)).must_equal true
    end

    it 'should return false on incorrect answer' do
      answer = 32_767
      test = Test.new([Exercise.new(['+'], 1, answer, 'a')])
      value(test.answer!(answer + 1)).must_equal false
    end

    it 'shuld raise exception when called on ended test' do
      test = Test.new([Exercise.new(['+'], 1, -1, 'a')])
      test.answer!(0)
      -> { test.answer!(451) }.must_raise Exception
    end

    it 'should set be ended when all exercises passed' do
      test = Test.new([Exercise.new(['+'], 1, 3.14, 'a')])
      test.answer!(0)
      value(test.ended?).must_equal true
    end
  end

  describe '#expected_count' do
    it 'should change if additional exercise used' do
      test = Test.new([Exercise.new(['+'], 1, 4, 'a')],
                      [Exercise.new(['+'], 1, 4, 'b')])
      prev_count = test.expected_count
      test.answer!(0)
      value(prev_count < test.expected_count).must_equal true
    end
  end
end
