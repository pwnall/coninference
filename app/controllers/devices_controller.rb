class DevicesController < ApplicationController
  before_action :authenticated_as_user
  before_action :set_device, only: [:show, :edit, :blink, :update, :destroy]

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
  end

  # GET /devices/1
  def show

  end

  # GET /devices/new
  def new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices/1/blink
  def blink
    @device.push_message cmd: 'blink', color: 'red', seconds: 10
    @device.push_message cmd: 'blink', color: 'green', seconds: 10
    @device.push_message cmd: 'blink', color: 'blue', seconds: 10
    respond_to do |format|
      format.html do
        redirect_to @device, notice: "#{@device.name} is blinking"
      end
    end
  end

  # POST /devices
  def create
    @registration = DeviceRegistration.new device_registration_params
    @registration.bar = @bar

    respond_to do |format|
      if @device = @registration.process
        format.html do
          redirect_to @device, notice: "#{@device.name} successfully linked."
        end
      else
        format.html do
          render :new
        end
      end
    end
  end

  # PATCH/PUT /devices/1
  def update
    respond_to do |format|
      if @device.update(device_params)
        @device.push_message cmd: 'reload'
        format.html do
          redirect_to @device, notice: "#{@device.name} successfully updated."
        end
      else
        format.html do
          render :show
        end
      end
    end
  end

  # DELETE /devices/1
  def destroy
    @device.push_message cmd: 'reload'
    @device.destroy
    respond_to do |format|
      format.html do
        redirect_to bar_devices_url(@device.bar),
            notice: "#{@device.name} successfully unlinked"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.with_url_name(params[:id]).first!
      bounce_user if @device.user and @device.user != current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:name)
    end

    def device_registration_params
      params.require(:device_registration).permit(:code)
    end
end
