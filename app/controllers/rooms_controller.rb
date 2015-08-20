class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :push_info]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # POST /rooms/1/push_info
  def push_info
    @room.update! push_url: params[:push_url]
    render json: {}
  end

  private
    def set_room
      @room = Room.with_url_name(params[:id]).first!
    end
end
