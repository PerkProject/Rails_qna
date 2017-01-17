require 'rails_helper'
require 'capybara/poltergeist'
require 'phantomjs'
require 'capybara/email/rspec'
# Capybara.default_wait_time = 5
# Capybara.register_driver :poltergeist do |app|
#  Capybara::Poltergeist::Driver.new(app, inspector: true)
# end
# Add additional requires below this line. Rails is not loaded until this point!
RSpec.configure do |config|
  Capybara.javascript_driver = :poltergeist

  options = { js_errors: false, phantomjs: Phantomjs.path }
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, options)
  end
  Capybara.register_driver :poltergeist_debug do |app|
    Capybara::Poltergeist::Driver.new(app, inspector: true, js_errors: false)
  end
  Capybara.javascript_driver = :poltergeist_debug
  Capybara.server = :puma

  config.include AcceptanceHelper, type: :feature
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end

  ActionDispatch::IntegrationTest
  Capybara.server_port = 3001
  Capybara.app_host = 'http://localhost:3001'
end
