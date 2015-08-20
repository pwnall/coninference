# A floor plan, such as Berry 4.
class Map < ActiveRecord::Base
  # User-friendly map name.
  validates :name, presence: true, length: 1..64

  # The name shown in URL segments.
  validates :url_name, presence: true, length: 1..32, format: /\A[a-z0-9]+\Z/
  include UrlNamed
  # Generate a URL segment name.
  def generate_url_name
    self.url_name ||=
        Base32.encode(SecureRandom.random_bytes(16)).downcase.sub(/=*$/, '')
  end

  # The user's push notifications key.
  validates :key, presence: true, length: 1..64, uniqueness: true
  before_validation :generate_key

  include PushReceiver

  # Ensures that the user's push notifications key is set.
  def generate_key
    self.key ||= SecureRandom.urlsafe_base64 32
  end
  private :generate_key

  has_many :rooms, dependent: :destroy
end
