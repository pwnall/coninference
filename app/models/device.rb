# An Edison board.
class Device < ActiveRecord::Base
  # The conference room in which this board has been installed.
  belongs_to :room, inverse_of: :devices

  # The device's login key.
  validates :key, presence: true, length: 1..64, uniqueness: true
  before_validation :generate_key

  # The name assigned to the device by the user.
  validates :name, length: 1..64
  before_validation :generate_name

  # The node.js version running on the device.
  validates :node_version, length: { in: 1..32, allow_nil: true }

  # The device's factory-issued serial number.
  validates :serial, length: { in: 1..64, allow_nil: true }

  # The name shown in URL segments.
  validates :url_name, presence: true, length: 1..32, format: /\A[a-z0-9]+\Z/
  include UrlNamed
  # Generate a URL segment name.
  def generate_url_name
    self.url_name ||=
        Base32.encode(SecureRandom.random_bytes(16)).downcase.sub(/=*$/, '')
  end

  include PushReceiver

  # Ensures that the device's key is set.
  def generate_key
    self.key ||= SecureRandom.urlsafe_base64 32
  end
  private :generate_key

  # Ensures that the device's name is set.
  def generate_name
    self.name ||= name_from_serial
  end
  private :generate_name

  # Updates the device's model info based on parameters.
  def update_model_info(params)
    node_version = params[:node_version]
    self.node_version = node_version if node_version and node_version != 'null'

    serial = params[:serial]
    self.serial = serial if serial and serial != 'null'

    save!
  end

  # Generates a device name based on its model.
  def name_from_serial
    if serial
      "Sensor #{serial}"
    elsif node_version
      "Sensor v#{node_version}"
    else
      'Sensor'
    end
  end

  # The sensor reading changes reported by this board.
  has_many :sensor_edges, dependent: :destroy
  include HasSensorEdges

  # Reacts based on sensor data.
  #
  # @param {Hash<String, Number>} sensor_diff sensors whose values have changed
  #   since the last reading
  # @param {Number} device_time the time the sensors have changed, according to
  #   the device's clock
  # @param {String} the app's root url
  def process_sensor_data(sensor_diff, device_time_js, root_url)
    device_time = Time.at(device_time_js / 1000.0)
    sensor_diff.each do |kind, value|
      sensor_edges.create! kind: kind, device_time: device_time, value: value
    end
    unless room.nil?
      room.sensors_changed self, sensor_diff
    end
  end
end
