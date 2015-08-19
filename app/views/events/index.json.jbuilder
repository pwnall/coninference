json.array!(@events) do |event|
  json.id event.url_name
  json.extract! event, :label, :started_at, :ended_at
  json.url event_url(event, format: :json)
end
