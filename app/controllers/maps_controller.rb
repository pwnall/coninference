class MapsController < ApplicationController
  before_action :set_map, only: [:show, :push_info]

  # Render the floorplan.
  def show
    render layout: 'full_screen'
  end

  # POST /maps/1/push_info
  def push_info
    @map.update! push_url: params[:push_url]
    render json: {}
  end

  private
    def set_map
      @map = Map.with_url_name(params[:id]).first!
    end
end
