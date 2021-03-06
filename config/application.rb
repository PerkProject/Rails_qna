# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller
    ActiveModelSerializers.config.adapter = :json
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_job.queue_adapter = :sidekiq
    config.action_cable.allowed_request_origins = ['http://95.213.200.206', 'http://localhost:3000']
    config.action_cable.disable_request_forgery_protection = false
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       controller_specs: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.template_engine :slim
      g.helper false
    end
    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes}
    # config.action_cable.url = 'ws://localhost:3000'
  end
end
