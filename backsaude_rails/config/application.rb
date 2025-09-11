require_relative "boot"
require "rails/all"
require "dotenv/load"

Bundler.require(*Rails.groups)

module BacksaudeRails
  class Application < Rails::Application
    # Configurações básicas
    config.load_defaults 8.0
    config.api_only = true

    # Autoload personalizado (remove pastas não-Ruby)
    config.autoload_lib(ignore: %w[assets tasks generators middleware templates])

    # Fuso horário (ajuste para sua região)
    config.time_zone = "Brasilia"
    config.active_record.default_timezone = :local

    # Locale
    config.i18n.default_locale = :'pt-BR'

    # Segurança
    config.action_dispatch.default_headers = {
      "X-Frame-Options" => "DENY",
      "X-Content-Type-Options" => "nosniff",
      "X-XSS-Protection" => "1; mode=block"
    }

    # Configurações específicas do ambiente
    if Rails.env.development?
      require "rails_db" # Ativa o RailsDB apenas em desenvolvimento
      config.hosts << /[a-z0-9-]+\.localhost/ # Permite hosts customizados
    end
    config.api_only = true
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use ActionDispatch::Flash
  end
end
