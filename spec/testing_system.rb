# frozen_string_literal: true

require_relative 'system_helper.rb'

describe 'Testing system' do
  it 'should display alert' do
    visit('/practice/general_test')
    fill_in('answer', with: '0')
    click_button('Ответить')
    while current_path == '/practice/general_test'
      value(page.has_content?('Верно!') ||
            page.has_content?('Ошибка')).must_equal true
      fill_in('answer', with: '0')
      click_button('Ответить')
    end
  end

  it 'should redirect to statistics' do
    visit('/practice/general_test')
    while current_path == '/practice/general_test'
      fill_in('answer', with: '0')
      click_button('Ответить')
    end
    value(current_path == '/practice/statistics').must_equal true
  end
end
