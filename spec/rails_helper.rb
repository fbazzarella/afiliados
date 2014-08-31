ENV["RAILS_ENV"] ||= "test"

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

Dir[File.expand_path('../support/*', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.extend  ControllerMacros,    type: :controller

  config.use_transactional_fixtures = true
  config.color = true
end
