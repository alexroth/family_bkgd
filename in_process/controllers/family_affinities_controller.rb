class FamilyAffinitiesController < ApplicationController
  # GET /family_affinities
  # GET /family_affinities.xml
  def index
    # ---------------------------------------------
    # index
    # Rev. 06/27/2012 to tweak @offset calculation and create method prep_nav_values
    # ---------------------------------------------
    @table_count = FamilyAffinity.count
    prep_nav_values( params )
    @family_affinities = FamilyAffinity.find( :all, 
        :order => 'name, relationship, connection_name', 
        :offset => @offset, :limit => @max_rows )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @family_affinities }
    end
  end

  # GET /family_affinities/1
  # GET /family_affinities/1.xml
  def show
    @family_affinity = FamilyAffinity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @family_affinity }
    end
  end

  # GET /family_affinities/new
  # GET /family_affinities/new.xml
  def new
    @family_affinity = FamilyAffinity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @family_affinity }
    end
  end

  # GET /family_affinities/1/edit
  def edit
    @family_affinity = FamilyAffinity.find(params[:id])
  end

  # POST /family_affinities
  # POST /family_affinities.xml
  def create
    @family_affinity = FamilyAffinity.new(params[:family_affinity])

    respond_to do |format|
      if @family_affinity.save
        flash[:notice] = 'FamilyAffinity was successfully created.'
        format.html { redirect_to(@family_affinity) }
        format.xml  { render :xml => @family_affinity, :status => :created, :location => @family_affinity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @family_affinity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /family_affinities/1
  # PUT /family_affinities/1.xml
  def update
    @family_affinity = FamilyAffinity.find(params[:id])

    respond_to do |format|
      if @family_affinity.update_attributes(params[:family_affinity])
        flash[:notice] = 'FamilyAffinity was successfully updated.'
        format.html { redirect_to(@family_affinity) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @family_affinity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /family_affinities/1
  # DELETE /family_affinities/1.xml
  def destroy
    @family_affinity = FamilyAffinity.find(params[:id])
    @family_affinity.destroy

    respond_to do |format|
      format.html { redirect_to(family_affinities_url) }
      format.xml  { head :ok }
    end
  end
end
