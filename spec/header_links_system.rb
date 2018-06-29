# frozen_string_literal: true

require_relative 'system_helper.rb'

describe 'Page header' do
  it 'should go to /theory' do
    visit('/')
    click_link('Теория')
    value(current_path).must_equal '/theory'
  end

  it 'should go to /practice' do
    visit('/')
    click_link('Практика')
    value(current_path).must_equal '/practice'
  end

  it 'should go to /' do
    visit('/theory')
    click_link('Главная')
    value(current_path).must_equal '/'
  end

  it 'should go to /practice/statistics' do
    visit('/practice/general_test')
    click_link('Статистика')
    value(current_path).must_equal '/practice/statistics'
  end
end
