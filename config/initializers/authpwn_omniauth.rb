# See the OmniAuth documentation for the contents of this file.
#
#     https://github.com/intridea/omniauth
#     https://github.com/intridea/omniauth/wiki

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  provider :twitter, Rails.application.secrets.twitter_api_key,
                     Rails.application.secrets.twitter_api_secret

  provider :google_oauth2, Rails.application.secrets.google_client_id,
      Rails.application.secrets.google_client_secret,
      name: 'google', access_type: 'online', scope: 'email'

  provider :github, Rails.application.secrets.github_client_id,
      Rails.application.secrets.github_client_secret, scope: 'user:email'
end


OmniAuth.config.logger = Rails.logger
