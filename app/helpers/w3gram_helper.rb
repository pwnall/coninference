module W3gramHelper
  def w3gram_setup_tag(receiver)
    w3gram_info = {
      server: Rails.application.secrets.w3gram_url,
      key: Rails.application.secrets.w3gram_app,
      device: receiver.key,
      token: receiver.push_token
    }

    case receiver
    when Map
      javascript_tag <<END_SCRIPT
W3gram.setupPushManager(#{w3gram_info.to_json});
window.coninferencePushUrl = #{push_info_map_url(receiver).to_json};
window.coninferenceMapUrl = #{map_url(receiver, format: 'json').to_json};
END_SCRIPT
    when Room
      javascript_tag <<END_SCRIPT
W3gram.setupPushManager(#{w3gram_info.to_json});
window.coninferencePushUrl = #{push_info_room_url(receiver).to_json};
window.coninferenceRoomUrl = #{room_url(receiver, format: 'json').to_json};
END_SCRIPT
    end
  end
end
