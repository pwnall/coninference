# Useful filter for controllers used by the in-device application.
module DeviceAppFilters
  # Loads the device key and user id from the session.
  def set_device_and_current_user
    if session[:device_key]
      @device = Device.where(key: session[:device_key]).first
    end

    if @device and @device.user
      self.current_user = @device.user
    else
      self.current_user = nil
    end
  end
  private :set_device_and_current_user

  # Ensures that the session belongs to a device registered to a user.
  def authenticated_as_user_device
    set_device_and_current_user
    redirect_to device_app_url unless @device and current_user
  end
end
