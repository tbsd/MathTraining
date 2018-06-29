# frozen_string_literal: true

require_relative 'system_helper.rb'

describe 'Statistics page' do
  it 'should click general_test button' do
    visit('/practice/general_test')
    click_link('Статистика')
    click_link('Общий тест')
    value(page.has_content?('Всего заданий пройдено')).must_equal true
  end

  it 'should click rule_test button' do
    visit('/practice/rule_test?rule=/')
    click_link('Статистика')
    click_link('Закрепление выбранного правила')
    value(page.has_content?('Всего заданий пройдено')).must_equal true
  end
end
