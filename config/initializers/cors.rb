# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

# TODO: set a production client origin
env_origins = Rails.env.production? ? 'TODO' : 'http://localhost:3001'

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins env_origins
    resource '*',
      headers: %w(Authorization),
      methods: :any,
      expose: %w(Authorization)
  end
end
