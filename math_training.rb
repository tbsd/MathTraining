# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'yaml'
require 'pp'
require_relative 'lib/exercise'
require_relative 'lib/yer'
require_relative 'lib/test'

enable :sessions

configure do
  set :max_dif, 3
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
  main_count = 2
  additional_count = 3
  dif_count = main_count / settings.max_dif
  main_list = []
  additional = []
  shuffled = settings.exercises_pool.shuffle
  # If max_dif isn't divisor of main_count
  main_list.concat(shuffled.pop(main_count % settings.max_dif))
  dif = 0
  while dif <= settings.max_dif
    same_dif = shuffled.find_all { |e| e.difficulty == dif }
    main_list.concat(same_dif.pop(dif_count))
    additional.concat(same_dif.pop(additional_count))
    dif += 1
  end
  session[:general_test] = Test.new(main_list.sort, additional.sort)
  @current_number = 1
  @total_number = session[:general_test].total_count
  # session[:page] = @current_number
  erb :general_test
end

post '/general_test' do
  @warnings = []
  @messages = []
  redirect to('/statistics') if session[:general_test].ended?
  if session[:general_test].answer!(params['answer'].to_f)
    @messages << 'Верно!'
  else
    @warnings << 'Ошибка.'
  end
  @current_number = session[:general_test].past_count + 1
  @total_number = session[:general_test].total_count
  redirect to('/statistics') if session[:general_test].ended?
  # session[:page] = @current_number
  erb :general_test
end

get '/statistics' do
  return redirect to('/practice') if session[:general_test].nil?
  @total = session[:general_test].total_count
  @correct = session[:general_test].correct_count
  @incorrect = @total - @correct
  @mistakes = session[:general_test].mistake_stats
  session[:general_test] = nil
  erb :statistics
end
