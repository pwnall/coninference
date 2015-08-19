module W3gramHelper
  def w3gram_setup_tag
    if current_user
      w3gram_info = {
        server: Rails.application.secrets.w3gram_url,
        key: Rails.application.secrets.w3gram_app,
        device: current_user.key,
        token: current_user.push_token
      }
      javascript_tag "W3gram.setupPushManager(#{w3gram_info.to_json});"
    end
  end
end
