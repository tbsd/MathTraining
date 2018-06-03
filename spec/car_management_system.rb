# coding: utf-8
require_relative 'system_helper.rb'

describe 'Car management' do
  it 'should add correct car to the list' do
    visit('/')
    click_link('add-car')
    fill_in('manufacturer', with: 'Lada')
    fill_in('year', with: 1960)
    click_on('Добавить машинку')
    value(page.has_content?('Lada')).must_equal true
    value(page.has_content?('1960')).must_equal true
  end

  it 'should show error when submitting empty form' do
    visit('/')
    click_link('add-car')
    click_on('Добавить машинку')
    value(page.has_css?('#add-errors')).must_equal true
  end

  it 'should allow to modify the car' do
    visit('/')
    #click_link('Редактировать')
    click_on("edit-car-0")
  end

  it 'should edit correct car to the list' do
    visit('/')
    click_link('edit-car-0')
    fill_in('manufacturer', with: 'Lada')
    fill_in('year', with: 1960)
    click_on('Добавить машинку')
    value(page.has_content?('Lada')).must_equal true
    value(page.has_content?('1960')).must_equal true
  end

  it 'should show error when submitting empty form' do
    visit('/')
    click_link('edit-car-0')
    click_on('Добавить машинку')
    value(page.has_css?('#add-errors')).must_equal true
  end
end
