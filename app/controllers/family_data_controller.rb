class FamilyDataController < ApplicationController
  before_action :set_family_datum, only: [:show, :edit, :update, :destroy]

  # GET /family_data
  # GET /family_data.json
  def index
    @family_data = FamilyDatum.all
  end

  # GET /family_data/1
  # GET /family_data/1.json
  def show
  end

  # GET /family_data/new
  def new
    @family_datum = FamilyDatum.new
  end

  # GET /family_data/1/edit
  def edit
  end

  # POST /family_data
  # POST /family_data.json
  def create
    @family_datum = FamilyDatum.new(family_datum_params)

    respond_to do |format|
      if @family_datum.save
        format.html { redirect_to @family_datum, notice: 'Family datum was successfully created.' }
        format.json { render action: 'show', status: :created, location: @family_datum }
      else
        format.html { render action: 'new' }
        format.json { render json: @family_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /family_data/1
  # PATCH/PUT /family_data/1.json
  def update
    respond_to do |format|
      if @family_datum.update(family_datum_params)
        format.html { redirect_to @family_datum, notice: 'Family datum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @family_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /family_data/1
  # DELETE /family_data/1.json
  def destroy
    @family_datum.destroy
    respond_to do |format|
      format.html { redirect_to family_data_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family_datum
      @family_datum = FamilyDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_datum_params
      params.require(:family_datum).permit(:name, :gender, :membid, :father, :fatherid, :mother, :motherid, :birth_date, :birth_place, :comment, :hash5, :created_at, :updated_at, :override_year)
    end
end
