ENV["RAILS_ENV"] ||= "test"

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

require 'sidekiq/testing'
Sidekiq::Testing.fake!

Dir[File.expand_path('../support/*', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.extend  HelperMethods

  config.use_transactional_fixtures = true
  config.formatter = Fuubar
  config.color = true

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

  config.after :suite do
    FileUtils.rm_rf("#{Rails.root}/tmp/lists/test")
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
