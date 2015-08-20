# A conference room reporting occupancy data.
class Room < ActiveRecord::Base
  # The user-friendly display name for the room.
  validates :name, presence: true, length: 1..64

  # The id attribute of the svg path that contains this room on the map.
  validates :dom_selector, presence: true, length: 1..64, uniqueness: true

  # True if the room's device has detected a human presence.
  validates :occupied, inclusion: { in: [true, false], allow_nil: false }

  # The floorplan that this room is on.
  belongs_to :map
  validates :map, presence: true

  # The sensor device installed in this room.
  has_one :device, inverse_of: :room

  # has_many :readings, through: :device, source: :sensor_edges
end
