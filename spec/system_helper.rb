# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require_relative 'spec_helper'
require_relative '../math_training.rb'

require 'capybara'
require 'capybara/dsl'
require 'capybara/minitest'
require 'rack/test'

class MiniTest::Spec
    include Capybara::DSL
    include Capybara::Minitest::Assertions
    include Rack::Test::Methods

    before do
      Capybara.app = Sinatra::Application.new
    end

    after do
      Capybara.reset_sessions!
      Capybara.use_default_driver
    end
end
