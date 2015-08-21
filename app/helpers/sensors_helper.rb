module SensorsHelper
  def sensor_kind_name(kind)
    case kind
    when :loudness
      'Cheap Microphone'
    when :micpower
      'Fancy Microphone'
    when :motion
      'PIR w/ Small Lens'
    when :opticalflow
      'Optical Flow'
    when :pirxl
      'PIR w/ Large Lens'
    when :vibration
      'Vibration'
    end
  end
end
