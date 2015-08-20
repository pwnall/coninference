module RoomsHelper
  # The text to describe a device's room.
  def device_room_name(device)
    device.room ? device.room.name : 'Unassigned'
  end
end
