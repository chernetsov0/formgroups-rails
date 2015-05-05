require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

require "formgroups-rails"

module Dummy
  class Application < Rails::Application
    config.assets.version = '1.0'
    config.active_record.raise_in_transactional_callbacks = true
    config.action_dispatch.cookies_serializer = :json
    config.session_store :cookie_store, key: '_dummy_session'
    config.filter_parameters += [:password]
  end
end

