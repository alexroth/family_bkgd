class FamilyStartPointsController < ApplicationController
  # GET /family_start_points
  # GET /family_start_points.xml
  def index
    @table_count = FamilyStartPoint.count
    prep_nav_values( params )
    @family_start_points = FamilyStartPoint.find( :all, 
        :order => 'family_descrip', 
        :offset => @offset, :limit => @max_rows )
    @name_for_membid = Hash.new
    @family_start_points.each { | family_start_point | 
        @name_for_membid[ family_start_point.membid ] = 
        FamilyDatum.find_by_membid( family_start_point.membid ).name if
        family_start_point.membid }
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @family_start_points }
    end
  end

  # GET /family_start_points/1
  # GET /family_start_points/1.xml
  def show
    @family_start_point = FamilyStartPoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @family_start_point }
    end
  end

  # GET /family_start_points/new
  # GET /family_start_points/new.xml
  def new
    @family_start_point = FamilyStartPoint.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @family_start_point }
    end
  end

  # GET /family_start_points/1/edit
  def edit
    @family_start_point = FamilyStartPoint.find(params[:id])
  end

  # POST /family_start_points
  # POST /family_start_points.xml
  def create
    @family_start_point = FamilyStartPoint.new(params[:family_start_point])

    respond_to do |format|
      if @family_start_point.save
        flash[:notice] = 'FamilyStartPoint was successfully created.'
        format.html { redirect_to(@family_start_point) }
        format.xml  { render :xml => @family_start_point, :status => :created, :location => @family_start_point }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @family_start_point.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /family_start_points/1
  # PUT /family_start_points/1.xml
  def update
    @family_start_point = FamilyStartPoint.find(params[:id])

    respond_to do |format|
      if @family_start_point.update_attributes(params[:family_start_point])
        flash[:notice] = 'FamilyStartPoint was successfully updated.'
        format.html { redirect_to(@family_start_point) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @family_start_point.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /family_start_points/1
  # DELETE /family_start_points/1.xml
  def destroy
    @family_start_point = FamilyStartPoint.find(params[:id])
    @family_start_point.destroy

    respond_to do |format|
      format.html { redirect_to(family_start_points_url) }
      format.xml  { head :ok }
    end
  end
end
