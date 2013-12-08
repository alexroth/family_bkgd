class FamilyStartPointsController < ApplicationController
  before_action :set_family_start_point, only: [:show, :edit, :update, :destroy]

  # GET /family_start_points
  # GET /family_start_points.json
  def index
    @family_start_points = FamilyStartPoint.all
  end

  # GET /family_start_points/1
  # GET /family_start_points/1.json
  def show
  end

  # GET /family_start_points/new
  def new
    @family_start_point = FamilyStartPoint.new
  end

  # GET /family_start_points/1/edit
  def edit
  end

  # POST /family_start_points
  # POST /family_start_points.json
  def create
    @family_start_point = FamilyStartPoint.new(family_start_point_params)

    respond_to do |format|
      if @family_start_point.save
        format.html { redirect_to @family_start_point, notice: 'Family start point was successfully created.' }
        format.json { render action: 'show', status: :created, location: @family_start_point }
      else
        format.html { render action: 'new' }
        format.json { render json: @family_start_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /family_start_points/1
  # PATCH/PUT /family_start_points/1.json
  def update
    respond_to do |format|
      if @family_start_point.update(family_start_point_params)
        format.html { redirect_to @family_start_point, notice: 'Family start point was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @family_start_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /family_start_points/1
  # DELETE /family_start_points/1.json
  def destroy
    @family_start_point.destroy
    respond_to do |format|
      format.html { redirect_to family_start_points_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family_start_point
      @family_start_point = FamilyStartPoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_start_point_params
      params.require(:family_start_point).permit(:family_descrip, :membid, :comment, :created_at, :updated_at)
    end
end
