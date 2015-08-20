Map.destroy_all
map = Map.create! name: 'Berry 4'
sync, check, heart = %w(sync check heart).map do |name|
  Room.new name: name.capitalize, map: map, dom_selector: name
end
sync.update! occupied: false
check.update! occupied: false
heart.update! occupied: true
