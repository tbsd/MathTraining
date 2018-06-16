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
  set :exercises_pool, DBIO.read_exercises
  set :user_data, DBIO.read_user_data
  set :root, __dir__
end

get '/' do
  pp session
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
  redirect to('/practice') if session[:general_test].nil?
  redirect to('/statistics?=general_test') if session[:general_test].ended?
  if session[:general_test].answer!(params['answer'].to_f)
    @messages << 'Верно!'
  else
    @warnings << 'Ошибка.'
  end
  @current_number = session[:general_test].past_count + 1
  @total_number = session[:general_test].total_count
  redirect to('/statistics?=general_test') if session[:general_test].ended?
  # session[:page] = @current_number
  erb :general_test
end

get '/statistics' do
  test = params[:test]
  redirect to('/practice') if session[test].nil?
  @total = session[test].total_count
  @correct = session[test].correct_count
  @incorrect = @total - @correct
  @mistakes = session[test].mistake_stats
  # session[test] = nil
  erb :statistics
end

get '/rule_choice' do
  erb :rule_choice
end

get '/rule_test' do
  redirect to('/rule_choice') unless params.key?(:rule)
  same_rule = settings.exercises_pool.find_all { |e| e.subject?(params[:rule]) }
  redirect to('/rule_choice') if same_rule.empty? # No such rule
  session[:rule_test] = Test.new(same_rule, [])
  erb :rule_test
end

post '/rule_test' do
  @warnings = []
  @messages = []
  redirect to('/rule_choice') if session[:rule_test].nil?
  redirect to('/statistics?=rule_test') if session[:rule_test].ended?
  if session[:rule_test].answer!(params['answer'].to_f)
    @messages << 'Верно!'
  else
    @warnings << 'Ошибка.'
  end
  redirect to('/statistics?=rule_test') if session[:rule_test].ended?
  # session[:page] = @current_number
  erb :rule_test
end

