# Included by models that use URL names.
module UrlNamed
  extend ActiveSupport::Concern

  included do
    before_validation :generate_url_name, on: :create
    scope :with_url_name, -> (url_name) { where(url_name: url_name) }
  end

  # Use url_name instead of the widget's internal ID.
  def to_param
    url_name
  end
end
