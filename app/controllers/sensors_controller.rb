class SensorsController < ApplicationController
  before_action :set_event
  before_action :set_device, only: [:index, :show]

  # GET /events/1/devices/1/sensors
  # GET /events/1/devices/1/sensors.json
  def index
  end

  # GET /events/1/devices/1/sensors/light
  # GET /events/1/devices/1/sensors/light.json
  def show
    sensor_kind = params[:id]
    @readings = @device.sensor_readings_for @event, sensor_kind

    respond_to do |format|
      format.json { render json: { readings: @readings } }
    end
  end

  # GET /events/1/devices
  # GET /events/1/devices.json
  def device_list
    @devices = Device.all
  end

  private
    def set_event
      @event = Event.with_url_name(params[:event_id]).first!
    end
    def set_device
      @device = Device.with_url_name(params[:device_id]).first!
    end
end
