# An experimental event.
class Event < ActiveRecord::Base
  # The user who created the experiment.
  belongs_to :user
  validates :user, presence: true

  # User-assigned label.
  validates :label, presence: true, length: 1..64

  # The time when the experiment started.
  validates :started_at, presence: true

  # The time when the experiment ended.
  validates :ended_at, presence: false

  # The name shown in URL segments.
  validates :url_name, presence: true, length: 1..32, format: /\A[a-z0-9]+\Z/
  include UrlNamed
  # Generate a URL segment name.
  def generate_url_name
    self.url_name ||=
        Base32.encode(SecureRandom.random_bytes(16)).downcase.sub(/=*$/, '')
  end
end
