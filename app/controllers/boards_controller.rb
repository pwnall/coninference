class BoardsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_device, only: [:show, :update, :sensors]
  before_action :set_cors_headers

  # GET /boards/1.json
  def show
  end

  # POST /boards.json
  def create
    @device = Device.new board_params

    respond_to do |format|
      if @device.save
        format.json do
          render :show, status: :created, location: board_url(@device.key)
        end
      else
        format.json do
          render json: @device.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /boards/1.json
  def update
    respond_to do |format|
      if @device.update(board_params)
        format.json do
          render :show, status: :ok, location: board_url(@device.key)
        end
      else
        format.json do
          render json: @device.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # OPTIONS /boards
  def cors_options
    response.headers['Access-Control-Allow-Methods'] = 'GET,POST,PUT'
    head :ok
  end

  # PUT /boards/1/sensors.json
  def sensors
    @device.process_sensor_data params[:sensors], params[:board_time], root_url
    render json: {}, status: :ok
  end

  private
    def set_device
      @device = Device.where(key: params[:id]).first!
    end
    def board_params
      params.require(:board).permit(:node_version, :serial, :push_url)
    end
    def set_cors_headers
      response.headers['Access-Control-Allow-Origin'] = '*'
      response.headers['Access-Control-Allow-Headers'] = 'Content-Type'
    end
end
