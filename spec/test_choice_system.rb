# frozen_string_literal: true

require_relative 'system_helper.rb'

describe 'Test choice for rule test' do
  it 'choose rule' do
    visit('/practice/rule_choice')
    click_on('Сложение')
    value(page.has_content?('Действие: "+"')).must_equal true
  end

  it 'choose rule' do
    visit('/practice/rule_choice')
    click_on('Вычитание')
    value(page.has_content?('Действие: "-"')).must_equal true
  end

  it 'choose rule' do
    visit('/practice/rule_choice')
    click_on('Умножение')
    value(page.has_content?('Действие: "*"')).must_equal true
  end

  it 'choose rule' do
    visit('/practice/rule_choice')
    click_on('Деление')
    value(page.has_content?('Действие: "/"')).must_equal true
  end
end
