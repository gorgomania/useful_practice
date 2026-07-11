require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UsefulPractice
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])
    config.i18n.default_locale = :ru

    config.action_view.field_error_proc = proc do |html_tag, _instance|
      fragment = Nokogiri::HTML5.fragment(html_tag)
      element = fragment.children.first
      if element && element.name == "input"
        element.remove_class("border-[#e5e5e5] bg-[#f2f2f2]")
        element.add_class("border-[#910a0a] bg-[#e7a0a0]")
      end
      fragment.to_html.html_safe
    end
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
