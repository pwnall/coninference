json.id @map.url_name
json.rooms @map.rooms do |room|
  json.extract! room, :dom_selector, :occupied
end
