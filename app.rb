require 'sinatra'
require 'sinatra/reloader' if development?
require 'pp'

configure do
  set :exercises, %w[das lll dasdsssssssad] # REMOVE ME mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
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
  @exercise = settings.exercises[-1]
  pp @exercise
  erb :general_test
end
