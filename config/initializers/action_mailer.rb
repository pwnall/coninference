unless Rails.env.test?
  Rails.application.config.action_mailer.delivery_method = :smtp
end

Rails.application.config.action_mailer.smtp_settings = {
  port: 587,
  address: 'smtp.gmail.com',
  user_name: Rails.application.secrets.gmail_email,
  password: Rails.application.secrets.gmail_password,
  domain: Rails.application.secrets.gmail_email.split('@').last,
  authentication: :plain,
  enable_starttls_auto: true
}
