# A change in value for the readings from a board's sensor.
class SensorEdge < ActiveRecord::Base
  # The device that the sensor readings belong to.
  belongs_to :device
  validates :device, presence: true

  # The sensor type.
  validates :kind, length: 1..16

  # The new value for the sensor.
  validates :value, numericality: true

  # The timestamp on the device.
  validates :device_time, presence: true

  # The types of sensors supported by the system.
  KINDS = Set.new [:light, :temperature, :micpower, :touch, :loudness, :motion]

  # Changes that occurred before a given time.
  scope :before, -> (time) { where('created_at <= ?', time) }
  # Changes that occurred after a given time.
  scope :after, -> (time) { where('created_at >= ?', time) }
end
