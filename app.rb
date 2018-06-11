# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'yaml'
require 'pp'
require_relative 'lib/exercise'
require_relative 'lib/yer'

enable :sessions

configure do
  set :max_difficulty, 2
  set :exercises_pool, YER.read_exercises
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
  session[:main_list] = []
  session[:additional] = []
  session[:past] = []
  same_difficulty_count = 9
  additional_count = 3
  shuffled = settings.exercises_pool.shuffle
  difficulty = 0
  while difficulty <= settings.max_difficulty
    same_difficulty = shuffled.select { |e| e.difficulty == difficulty }
    session[:main_list].concat(same_difficulty.pop(same_difficulty_count))
    session[:additional].concat(same_difficulty.pop(additional_count))
    difficulty += 1
  end
  session[:current_exercise] = session[:main_list].shift
  @current_number = 1
  @total_number = session[:main_list].size + 1
  session[:page] = @current_number
  erb :general_test
end

post '/general_test' do
  @warnings = []
  @messages = []
  session[:past] << session[:current_exercise]
  # replace if with next_exercise method????????????????????????????????
  if params['answer'].to_f == session[:current_exercise].answer
    session[:current_exercise].correct = true
    @messages << 'Верно!'
    session[:current_exercise] = session[:main_list].shift
  else
    session[:current_exercise].correct = false
    @warnings << 'Ошибка!'
    new_ex = session[:additional].find do |e|
      e.difficulty == session[:current_exercise].difficulty
    end
    if new_ex.nil?
      @messages << 'Дополнительных заданий на этом уровне сложности больше нет.'
      session[:current_exercise] = session[:main_list].shift
    else
      @messages << 'Решите дополнительное задание.'
      session[:current_exercise] = session[:additional].delete(new_ex)
    end
  end
  return redirect to('/statistics') if session[:current_exercise].nil?
  @current_number = session[:past].size + 1
  @total_number = session[:past].size + session[:main_list].size + 1
  session[:page] = @current_number
  erb :general_test
end

get '/statistics' do
  return redirect to('/') if session[:past].nil?
  @total = session[:past].length
  @correct = session[:past].count(&:correct?)
  incorrect_array = session[:past].take_while { |e| !e.correct? }
  @incorrct = incorrect_array.length
  @mistakes = { :+ => 0, :- => 0, :* => 0, :/ => 0 }
  @mistakes.each_key do |key|
    @mistakes[key] = incorrect_array.count { |e| e.subject_present?(key.to_s) }
  end
  erb :statistics
end
