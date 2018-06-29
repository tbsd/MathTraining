# frozen_string_literal: true

require_relative 'lib/dbio'

user_data = DBIO.read_user_data
user_data ||= {} # if DBIO.read_user_data returned false (empty file)
at_exit { DBIO.save_user_data(user_data) }

require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/reloader' if development?
require 'pp'
require 'securerandom'
require_relative 'lib/exercise'
require_relative 'lib/test'

enable :sessions

configure do
  set :main_count, 25
  set :additional_count, 3
  set :max_dif, 3
  set :exercises_pool, DBIO.read_exercises
  set :warnings, []
  set :messages, []
  set :root, __dir__
end

before '/practice/*' do
  id = request.cookies['user_id']
  if id.nil?
    new_id = SecureRandom.hex(32)
    cookies['user_id'] = new_id
    user_data[new_id] = { 'general_test' => nil, 'rule_test' => nil }
    id = new_id
  end
  session['user_id'] = id
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

get '/practice/general_test' do
  id = session['user_id']
  last_test = user_data[id]['general_test']
  if last_test.nil? || last_test.ended?
    dif_count = settings.main_count / settings.max_dif
    main_list = []
    additional = []
    shuffled = settings.exercises_pool.shuffle
    # If max_dif isn't divisor of settings.main_count
    main_list.concat(shuffled.pop(settings.main_count % settings.max_dif))
    dif = 0
    while dif <= settings.max_dif
      same_dif = shuffled.find_all { |e| e.difficulty == dif }
      main_list.concat(same_dif.pop(dif_count))
      additional.concat(same_dif.pop(settings.additional_count))
      dif += 1
    end
    user_data[id]['general_test'] = Test.new(main_list.sort, additional.sort)
    last_test = user_data[id]['general_test']
  else
    @warnings = settings.warnings
    @messages = settings.messages
  end
  @test = last_test
  @current_number = @test.past_count + 1
  @expected_number = @test.expected_count
  erb :testing
end

post '/practice/general_test' do
  settings.warnings = []
  settings.messages = []
  id = session['user_id']
  test = user_data[id]['general_test']
  redirect to('/practice') if test.nil?
  redirect to('/practice/statistics?test=general_test') if test.ended?
  if params['answer'] == ''
    settings.warnings << 'Введите ответ.'
    redirect to('practice/general_test')
  end
  if test.answer!(params['answer'].to_f)
    settings.messages << 'Верно!'
  else
    settings.warnings << 'Ошибка.'
  end
  redirect to('/practice/statistics?test=general_test') if test.ended?
  redirect to('/practice/general_test')
end

get '/practice/statistics' do
  id = session['user_id']
  test_name = params[:test]
  @user = user_data[id]
  return erb :statistics_choice if test_name.nil?
  test = user_data[id][test_name]
  redirect to('/practice/statistics') if test.nil?
  @total = test.past_count
  @correct = test.correct_count
  @incorrect = @total - @correct
  @mistakes = test.mistake_stats
  erb :statistics
end

get '/practice/rule_choice' do
  id = session['user_id']
  user_data[id]['rule_test'].abort! unless user_data[id]['rule_test'].nil?
  erb :rule_choice
end

get '/practice/rule_test' do
  id = session['user_id']
  redirect to('/practice/rule_choice') unless params.key?(:rule)
  if user_data[id]['rule_test'].nil? || user_data[id]['rule_test'].ended?
    same_rule = settings.exercises_pool.find_all do |e|
      e.subject?(params[:rule])
    end
    redirect to('/practice/rule_choice') if same_rule.empty? # No such rule
    user_data[id]['rule_test'] = Test.new(same_rule.shuffle)
  else
    @warnings = settings.warnings
    @messages = settings.messages
  end
  @test = user_data[id]['rule_test']
  # erb :rule_test
  @current_number = @test.past_count + 1
  @expected_number = @test.expected_count
  @test_name = "Действие: \"#{params[:rule]}\""
  erb :testing
end

post '/practice/rule_test' do
  id = session['user_id']
  rule = if params[:rule] == '+'
           '%2B'
         else
           params[:rule]
         end
  test = user_data[id]['rule_test']
  settings.warnings = []
  settings.messages = []
  redirect to('/practice/rule_choice') if test.nil?
  redirect to('/practice/statistics?test=rule_test') if test.ended?
  if params['answer'] == ''
    settings.warnings << 'Введите ответ.'
    redirect to("practice/rule_test?rule=#{rule}")
  end
  if test.answer!(params['answer'].to_f)
    settings.messages << 'Верно!'
  else
    settings.warnings << 'Ошибка.'
  end
  redirect to('/practice/statistics?test=rule_test') if test.ended?
  redirect to("practice/rule_test?rule=#{rule}")
end
