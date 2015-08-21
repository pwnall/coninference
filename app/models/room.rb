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

  # The sensor devices installed in this room.
  has_many :devices, inverse_of: :room, dependent: :nullify

  # Sensor data coming from this room.
  has_many :sensor_edges, through: :devices
  include HasSensorEdges

  # The name shown in URL segments.
  validates :url_name, presence: true, length: 1..32, format: /\A[a-z0-9]+\Z/
  include UrlNamed
  # Generate a URL segment name.
  def generate_url_name
    self.url_name ||=
        Base32.encode(SecureRandom.random_bytes(16)).downcase.sub(/=*$/, '')
  end

  # The floor plan's push notifications key.
  #
  # Users subscribe to this when seeing a floor plan.
  validates :key, presence: true, length: 1..64, uniqueness: true
  before_validation :generate_key

  include PushReceiver

  # Ensures that the user's push notifications key is set.
  def generate_key
    self.key ||= SecureRandom.urlsafe_base64 32
  end
  private :generate_key

  # Called when any of the room's sensors change.
  def sensors_changed(device, sensor_diff)
    self.occupied = self.occupied_from_sensors
    if self.changed?
      save!
      map.push_message cmd: 'rooms-changed'
    end
    push_message cmd: 'room-sensors-changed'
  end

  # Computes whether the room is occupied or not, based on sensor values.
  def occupied_from_sensors
    sensors = sensors_at Time.current
    return true if sensors[:pirxl] && sensors[:pirxl] > 0
    return true if sensors[:motion] && sensors[:motion] > 0
    return true if sensors[:micpower] && sensors[:micpower] > -45
    return true if sensors[:opticalflow] && sensors[:opticalflow] > 2
    false
  end
end
