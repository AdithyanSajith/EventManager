require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module EventManage
  class Application < Rails::Application
    config.load_defaults 7.2

    # Remove or comment this out 👇
    config.autoload_lib(ignore: %w[assets tasks])

    config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join("extras")
  end
end
