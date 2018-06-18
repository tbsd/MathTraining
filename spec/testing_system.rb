
# frozen_string_literal: true

require_relative 'system_helper.rb'

describe 'Testing system' do
  it 'should display alert' do
    visit('/practice/general_test')
    fill_in('answer', with: '0')
    click_button('Ответить')
    value(page.has_content?('Верно!') ||
          page.has_content?('Ошибка')).must_equal true
  end

  it 'should redirect to statistics' do
    visit('/practice/general_test')
    while current_path == '/practice/general_test'
      fill_in('answer', with: '0')
      click_button('Ответить')
    end
    value(current_path == '/practice/statistics').must_equal true
  end

  it 'choose rule' do
    visit('/practice/rule_choice')
    click_on('Сложение')
    value(page.has_content?('Вычислите:')).must_equal true
  end
end
