class FamilyAliasesController < ApplicationController
  before_action :set_family_alias, only: [:show, :edit, :update, :destroy]

  # GET /family_aliases
  # GET /family_aliases.json
  def index
    @family_aliases = FamilyAlias.all
  end

  # GET /family_aliases/1
  # GET /family_aliases/1.json
  def show
  end

  # GET /family_aliases/new
  def new
    @family_alias = FamilyAlias.new
  end

  # GET /family_aliases/1/edit
  def edit
  end

  # POST /family_aliases
  # POST /family_aliases.json
  def create
    @family_alias = FamilyAlias.new(family_alias_params)

    respond_to do |format|
      if @family_alias.save
        format.html { redirect_to @family_alias, notice: 'Family alias was successfully created.' }
        format.json { render action: 'show', status: :created, location: @family_alias }
      else
        format.html { render action: 'new' }
        format.json { render json: @family_alias.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /family_aliases/1
  # PATCH/PUT /family_aliases/1.json
  def update
    respond_to do |format|
      if @family_alias.update(family_alias_params)
        format.html { redirect_to @family_alias, notice: 'Family alias was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @family_alias.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /family_aliases/1
  # DELETE /family_aliases/1.json
  def destroy
    @family_alias.destroy
    respond_to do |format|
      format.html { redirect_to family_aliases_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family_alias
      @family_alias = FamilyAlias.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_alias_params
      params.require(:family_alias).permit(:name, :membid, :type_of_name, :alias_name, :alias_hash5, :comment, :created_at, :updated_at, :other_type_value)
    end
end
