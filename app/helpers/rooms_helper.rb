module RoomsHelper
  # The text to describe a device's room.
  def device_room_name(device)
    device.room ? device.room.name : 'Unassigned'
  end

  def room_occupancy_indicator(room)
    occupancy = room.occupied? ? 'busy' : 'free'
    classes = ['occupancy-indicator', occupancy].join ' '
    content_tag :div, class: classes do
      occupancy.capitalize
    end
  end
end
