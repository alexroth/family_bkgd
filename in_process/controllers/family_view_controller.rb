# class FamilyViewController
# 
# Controller for view-only of family_db
#
# Written 09/24/2012 A.D. Roth
# -------------------------------------
class FamilyViewController < ApplicationController
  # GET /family_start_points
  # GET /family_start_points.xml
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
  # ---------------------------------------------
  # show
  #
  # Rev. 07/02-11/2012
  # Rev. 08/21/2012 to improve alias search
  # ---------------------------------------------
  def show
    require 'general_helpers_201207'
    require 'family_helpers'
    if params[ :membid ]
      @family_datum = FamilyDatum.find_by_membid( params[ :membid ] )
    elsif params[ :name ]
      @family_datum = FamilyDatum.find_by_name( params[ :name ] )
    else
      @family_datum = FamilyDatum.find( params[ :id ] )
    end
    @show_name =  ( @family_datum.name ? @family_datum.name : '' ) #  @show_name is for heading in layout
    setup_for_show( @family_datum.name ) if @family_datum.name
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @family_datum }
    end
  end  #  show
  # -----------------------------------------
  # tree
  #
  #    One cell consists of record with generation level.
  #
  # Written 09/24/2012 A.D. Roth based on family_data#tree
  # -----------------------------------------
  def tree
    require 'general_helpers_201207'
    require 'family_helpers'
    # @show_obj = DisplayInfo.new
    @gen_limit = 3
    #  puts; puts "On entry to tree in controller, params are #{ params.inspect } and the record is " + 
    #      convert_record_to_line( FamilyDatum.find( params[ :id ] ) )
    @col_heads = Array.new
    FamilyDatum.columns.each { | one_col | @col_heads <<  one_col.name }
    @family_datum = ( params[ :membid ].nil? ? FamilyDatum.find( params[ :id ] ) : 
        FamilyDatum.find( params[ :membid ] ) )
    if @family_datum.name then
      @name = @family_datum.name
      # set up table
      @cell_array = prep_cell_array( "horizontal", @family_datum, @gen_limit )  # drop gen = element 0
      orientation = @cell_array.shift
      #  set up children
      setup_for_show( @family_datum.name ) if @family_datum.name
      @children = ( @family_datum.gender == "m" ? 
          FamilyDatum.find_all_by_father( @name, :order => "birth_date, name" ) :
          FamilyDatum.find_all_by_mother( @name, :order => "birth_date, name" ) )
    else
      flash.now[:notice] = "Person for id #{ params[:id].inspect } not on file"
      @name = ""
    end
    #  puts 'Now going to view'
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @family_datum }
    end
  end  #  tree
  # -----------------------------------------
  # show_list
  #
  # Written 09/24/2012 A.D. Roth based on family_data#show_list
  # -----------------------------------------
  def show_list
    require 'family_helpers'
    # ----------------- Begin show_list MAIN ---------------------------
    cand_list = Array.new  #  list of membid's of candidates
    @name = params['family_datum']['name']
    @name = '' if @name.nil?
    @cand_rcds = srch_for_name( @name )  #  input is @name, output is @cand_rcds array
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @family_data }
    end
  end  #  show_list
end
