class MetroStationsController < ApplicationController
  before_action :set_metro_station, only: %i[ show edit update destroy ]

  # GET /metro_stations or /metro_stations.json
  def index
    @metro_stations = MetroStation.where(find_all_filters)
  end

  def route
    @metro_stations = MetroStation.all
  end

  # GET /metro_stations/1 or /metro_stations/1.json
  def show
  end

  # GET /metro_stations/new
  def new
    @metro_station = MetroStation.new
  end

  # GET /metro_stations/1/edit
  def edit
  end

  # POST /metro_stations or /metro_stations.json
  def create
    @metro_station = MetroStation.new(metro_station_params)

    respond_to do |format|
      if @metro_station.save
        format.html { redirect_to metro_station_url(@metro_station), notice: "Metro station was successfully created." }
        format.json { render :show, status: :created, location: @metro_station }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @metro_station.errors, status: :unprocessable_entity }
      end
      format.turbo_stream
    end
  end

  # PATCH/PUT /metro_stations/1 or /metro_stations/1.json
  def update
    respond_to do |format|
      if @metro_station.update(metro_station_params)
        format.html { redirect_to metro_station_url(@metro_station), notice: "Metro station was successfully updated." }
        format.json { render :show, status: :ok, location: @metro_station }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @metro_station.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /metro_stations/1 or /metro_stations/1.json
  def destroy
    @metro_station.destroy

    respond_to do |format|
      format.html { redirect_to metro_stations_url, notice: "Metro station was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metro_station
      @metro_station = MetroStation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def metro_station_params
      params.require(:metro_station).permit(:node_id, :x, :y, :name)
    end

    def find_all_filters
      if params[:unset]
        {x: nil}
      else
        {}
      end
    end
end
