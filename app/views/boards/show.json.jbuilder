json.key @device.key
json.push do
  json.server Rails.application.secrets.w3gram_url
  json.key Rails.application.secrets.w3gram_app
  json.device @device.key
  json.token @device.push_token
end
json.name @device.name
