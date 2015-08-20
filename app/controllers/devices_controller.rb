class DevicesController < ApplicationController
  before_action :authenticated_as_user
  before_action :set_device, only: [:show, :edit, :blink, :update, :destroy]

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
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
        redirect_to devices_url, notice: "#{@device.name} is blinking"
      end
    end
  end

  # PATCH/PUT /devices/1
  def update
    respond_to do |format|
      if @device.update(device_params)
        @device.push_message cmd: 'reload'
        format.html do
          redirect_to devices_url,
              notice: "#{@device.name} successfully updated."
        end
      else
        format.html do
          render :edit
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
        redirect_to devices_url,
            notice: "Device #{@device.name} successfully removed"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.with_url_name(params[:id]).first!
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:name, :room_id)
    end

    def device_registration_params
      params.require(:device_registration).permit(:code)
    end
end
