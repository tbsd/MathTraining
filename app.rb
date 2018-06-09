# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'yaml'

configure do
  set :exercises, YAML.load_file('data/exercises.yaml')
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
  erb :general_test
end
