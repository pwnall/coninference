Room.destroy_all
sync, check, heart = %w(sync check heart).map do |name|
  Room.new name: name, map_id: name
end
sync.update! occupied: false
check.update! occupied: false
heart.update! occupied: true
