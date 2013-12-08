class FamilyDataController < ApplicationController
  # GET /family_data
  # GET /family_data.xml
  # ---------------------------------------------
  # index
  #
  # Rev. 06/27/2012 to tweak @offset calculation and create method prep_nav_values
  # Rev. 07/17/2012 to add require for general_helpers_201207, new home for prep_nav_values
  # ---------------------------------------------
  def index
    require 'general_helpers_201207'
    @table_count = FamilyDatum.count
    prep_nav_values( params, 10 )
    @family_data = FamilyDatum.find( :all, :order => "name", :offset => @offset, :limit => @max_rows )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @family_data }
    end
  end  #  index

  # GET /family_data/1
  # GET /family_data/1.xml
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
  # Written 07/12-08/04/2012 A.D. Roth
  # -----------------------------------------
  def tree
    require 'general_helpers_201109'
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
  # Written 06/28/2012 A.D. Roth
  # Rev. 07/03-05/2012 to add any one name; also alias names and alias hash5
  # Rev. 08/21/2012 to change sort order for cand_aliases to alias_name from membid
  # -----------------------------------------
  def show_list
    require 'family_helpers'
    # ----------------- Begin show_list MAIN ---------------------------
    #  puts "entering show_list, params[\"name\"] = #{params['name'].inspect }"
    #  puts "entering show_list, params[\"family_datum\"] = #{params['family_datum'].inspect }"
    #  puts "entering show_list, params['family_datum']['name'] = #{params['family_datum']['name'].inspect }"
    cand_list = Array.new  #  list of membid's of candidates
    @name = params['family_datum']['name']
    @name = params['name'] if @name.nil? && params['name']
    @name = '' if @name.nil?
    @cand_rcds = srch_for_name( @name )  #  input is @name, output is @cand_rcds array
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @family_data }
    end
  end  #  show_list

  # GET /family_data/new
  # GET /family_data/new.xml
  # -----------------------------------------
  # new
  #
  # Rev. 07/11/2012 to add prefill for father or mother
  # -----------------------------------------
  def new
    puts "At beginning of method 'new' in controller, params are " +
        convert_hash_to_line( params )
    @family_datum = FamilyDatum.new
    puts "@family_datum created of class #{ @family_datum.class }."
    #  @family_datum['name'] = ''
    #  puts "@family_datum now #{ @family_datum.inspect }."
    #  @family_datum.name = params[ :name ] unless params[ :name ].nil?
    @father_name = params[ :father ] if params[ :father ]
    @fatherid = params[ :fatherid ] if params[ :fatherid ]
    @mother_name = params[ :mother ] if params[ :mother ]
    @motherid = params[ :motherid ] if params[ :motherid ]
    #  if params[ :father ]
    #    @family_datum.father = params[ :father ]
    #    @family_datum.fatherid = params[ :fatherid ] if params[ :fatherid ]
    #  elsif params[ :mother ]
    #    @family_datum.mother = params[ :mother ]
    #    @family_datum.motherid = params[ :motherid ] if params[ :motherid ]
    #  end
    puts "At end of method 'new' in controller, @family_datum is class #{ @family_datum.class }" # +
    #    "#{ @family_datum.length } members."
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @family_datum }
    end
  end  #  new
  # GET /family_data/1/edit
  # -----------------------------------------
  # edit
  #
  # Rev. 
  # -----------------------------------------
  def edit
    require 'general_helpers_201109'
    @family_datum = FamilyDatum.find(params[:id])
    @family_datum.membid = @family_datum.id if !@family_datum.membid
    @initial_year = ( @family_datum.birth_date ? @family_datum.birth_date.year.to_i :
        @family_datum.override_year )
    @old_name = @family_datum.name
  end  #  edit

  # POST /family_data
  # POST /family_data.xml
  # -----------------------------------------
  # create
  #
  # Rev. 09/26/2012 to revise override_year field
  # -----------------------------------------
  def create
    require 'general_helpers_201207'
    @family_datum = FamilyDatum.new( params[ :family_datum ] )
    override_year = ( @family_datum.override_year ? @family_datum.override_year : "None" )
    #  override_year = ( params[ :override_year ] ? params[ :override_year ] : "None" )
    #  puts "override_year is #{ override_year.inspect }"
    #  puts "@family_datum is #{ @family_datum.inspect }"
    respond_to do |format|
      # do update here
      @family_datum.hash5 = @family_datum[ :name ].my_string_hash( 5 ) if @family_datum[ :name ].class == String
      if @family_datum.save
        flash[:notice] = "'" + @family_datum[ :name ].to_s + "' record was successfully created."
        @family_datum[ :membid ] = @family_datum[ :id ]
        @family_datum.birth_date = Date.new( override_year.to_i, 
            @family_datum.birth_date.month, @family_datum.birth_date.day ) if 
            @family_datum.birth_date
        #  puts "@family_datum.birth_date is #{ @family_datum.birth_date.inspect }"
        @family_datum.save
        @family_datum.reload
        #  puts "for newly created individual record, @family_datum with membid is #{ @family_datum.inspect }"
        format.html { redirect_to(@family_datum) }
        format.xml  { render :xml => @family_datum, :status => :created, :location => @family_datum }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @family_datum.errors, :status => :unprocessable_entity }
      end
    end
  end  #  create

  # PUT /family_data/1
  # PUT /family_data/1.xml
  # -----------------------------------------
  # update
  #
  # Rev. 07/17/2012 to add override_year field
  # Rev. 09/26/2012 to revise override_year field
  # -----------------------------------------
  def update
    require 'general_helpers_201109'
    @family_datum = FamilyDatum.find(params[:id])
    override_year = ( @family_datum.override_year ? @family_datum.override_year : "None" )
    #  puts "override_year is #{ override_year.inspect }"
    respond_to do |format|
      if @family_datum.update_attributes( params[ :family_datum ] )
        flash[:notice] = 'FamilyDatum was successfully updated.'
        @family_datum.hash5 = @family_datum.name.my_string_hash( 5 )
        @family_datum.membid = @family_datum.id if !@family_datum.membid
        @family_datum.birth_date = Date.new( override_year.to_i, 
            @family_datum.birth_date.month, @family_datum.birth_date.day ) if 
            @family_datum.birth_date
        @family_datum.save
        @family_datum.reload
        #  puts "for " + @family_datum.name + ", hash5 is " + @family_datum.hash5
        format.html { redirect_to(@family_datum) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @family_datum.errors, :status => :unprocessable_entity }
      end
    end
  end  #  update

  # DELETE /family_data/1
  # DELETE /family_data/1.xml
  # -----------------------------------------
  # destroy
  #
  # Rev. 
  # -----------------------------------------
  def destroy
    @family_datum = FamilyDatum.find(params[:id])
    @family_datum.destroy

    respond_to do |format|
      format.html { redirect_to(family_data_url) }
      format.xml  { head :ok }
    end
  end
end
