require File.expand_path('../boot', __FILE__)

require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module Panoptes
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '**/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'serializers', '**/')]

    config.middleware.insert_before ActionDispatch::ParamsParser, "RejectPatchRequests"
    config.action_controller.action_on_unpermitted_parameters = :raise
    config.middleware.insert_before ActionDispatch::ParamsParser, "CatchApiJsonParseErrors"
  end
end
