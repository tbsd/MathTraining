# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'yaml'
require 'pp'
require_relative 'lib/exercise'
require_relative 'lib/yer'

configure do
  set :max_difficulty, 2
  set :current_exercise, nil
  set :exercises_pool, YER.read_exercises
  set :main_list, []
  set :additional, []
  set :past, []
  # set :messages, []
  # set :warnings, []
  set :root, __dir__
end

get '/' do
  erb :main
end

get '/practice' do
  erb :practice
end

get '/theory' do
  erb :theory
end

get '/general_test' do
  settings.main_list = []
  settings.additional = []
  settings.past = []
  same_difficulty_count = 1
  additional_count = 0
  shuffled = settings.exercises_pool.shuffle
  difficulty = 0
  while difficulty <= settings.max_difficulty
    same_difficulty = shuffled.select { |e| e.difficulty == difficulty }
    settings.main_list.concat(same_difficulty.pop(same_difficulty_count))
    settings.additional.concat(same_difficulty.pop(additional_count))
    difficulty += 1
  end
  settings.current_exercise = settings.main_list.shift
  @current_number = 1
  @total_number = settings.main_list.size + 1
  erb :general_test
end

post '/general_test' do
  @warnings = []
  @messages = []
  settings.past << settings.current_exercise
  answer = params['answer']
  if answer.to_f == settings.current_exercise.answer
    settings.current_exercise.correct = true
    @messages << 'Верно!'
    settings.current_exercise = settings.main_list.shift
  else
    settings.current_exercise.correct = false
    @warnings << 'Ошибка!'
    new_ex = settings.additional.find do |e|
      e.difficulty == settings.current_exercise.difficulty
    end
    if new_ex.nil?
      @messages << 'Дополнительных заданий на этом уровне сложности больше нет.'
      settings.current_exercise = settings.main_list.shift
    else
      @messages << 'Решите дополнительное задание.'
      settings.current_exercise = settings.additional.delete(new_ex)
    end
  end
  return redirect to('/statistics') if settings.current_exercise.nil?
  @current_number = settings.past.size + 1
  @total_number = settings.past.size + settings.main_list.size + 1
  erb :general_test
end

get '/statistics' do
  'hello there'
end
