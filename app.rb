# coding: utf-8
require 'sinatra'
require 'sinatra/reloader' if development?

configure do
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
