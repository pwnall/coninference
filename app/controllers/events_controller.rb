class EventsController < ApplicationController
  before_action :authenticated_as_user, only: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = current_user.events.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new user: current_user
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @event.started_at = Time.current

    respond_to do |format|
      if @event.save
        format.html do
          redirect_to edit_event_url(@event),
              notice: "Experiment #{@event.label} started."
        end
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @event.ended_at ||= Time.current
    respond_to do |format|
      if @event.update event_params
        format.html do
          redirect_to events_url, notice: "Experiment #{@event.label} ended."
        end
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html do
        redirect_to events_url, notice: "Experiment #{@event.label} deleted."
      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.with_url_name(params[:id]).first!
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:label)
    end
end
