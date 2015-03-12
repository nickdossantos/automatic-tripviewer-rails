Rails.application.config.middleware.use(OmniAuth::Builder) do
  provider :automatic, ENV.fetch('AUTOMATIC_CLIENT_ID'), ENV.fetch('AUTOMATIC_CLIENT_SECRET'), {
    provider_ignores_state: true
  }
end
