module W3gramHelper
  def w3gram_setup_tag(map)
    w3gram_info = {
      server: Rails.application.secrets.w3gram_url,
      key: Rails.application.secrets.w3gram_app,
      device: map.key,
      token: map.push_token
    }
    javascript_tag <<END_SCRIPT
W3gram.setupPushManager(#{w3gram_info.to_json});
window.coninferencePushUrl = #{push_info_map_url(map).to_json};
window.coninferenceMapUrl = #{map_url(map, format: 'json').to_json};
END_SCRIPT
  end
end
