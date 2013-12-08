class WelcomeController < ApplicationController
  # ---------------------------
  # index
  #
  # Written 09/24/2012 A.D. Roth based on family_start_points#index
  # ---------------------------
  def index
    require 'general_helpers_201207'
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
end
