class FamilyAffinitiesController < ApplicationController
  before_action :set_family_affinity, only: [:show, :edit, :update, :destroy]

  # GET /family_affinities
  # GET /family_affinities.json
  def index
    @family_affinities = FamilyAffinity.all
  end

  # GET /family_affinities/1
  # GET /family_affinities/1.json
  def show
  end

  # GET /family_affinities/new
  def new
    @family_affinity = FamilyAffinity.new
  end

  # GET /family_affinities/1/edit
  def edit
  end

  # POST /family_affinities
  # POST /family_affinities.json
  def create
    @family_affinity = FamilyAffinity.new(family_affinity_params)

    respond_to do |format|
      if @family_affinity.save
        format.html { redirect_to @family_affinity, notice: 'Family affinity was successfully created.' }
        format.json { render action: 'show', status: :created, location: @family_affinity }
      else
        format.html { render action: 'new' }
        format.json { render json: @family_affinity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /family_affinities/1
  # PATCH/PUT /family_affinities/1.json
  def update
    respond_to do |format|
      if @family_affinity.update(family_affinity_params)
        format.html { redirect_to @family_affinity, notice: 'Family affinity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @family_affinity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /family_affinities/1
  # DELETE /family_affinities/1.json
  def destroy
    @family_affinity.destroy
    respond_to do |format|
      format.html { redirect_to family_affinities_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family_affinity
      @family_affinity = FamilyAffinity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_affinity_params
      params.require(:family_affinity).permit(:name, :membid, :relationship, :other_type_value, :connection_name, :connection_membid, :comment, :created_at, :updated_at)
    end
end
