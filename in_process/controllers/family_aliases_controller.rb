class FamilyAliasesController < ApplicationController
  # GET /family_aliases
  # GET /family_aliases.xml
  # ---------------------------------------------
  # index
  #
  # Rev. 06/27/2012 to tweak @offset calculation and create method prep_nav_values
  # ---------------------------------------------
  def index
    @table_count = FamilyAlias.count
    prep_nav_values( params )
    @family_aliases = FamilyAlias.find( :all, :order => 'name, type_of_name, alias_name', 
        :offset => @offset, :limit => @max_rows )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @family_aliases }
    end
  end

  # GET /family_aliases/1
  # GET /family_aliases/1.xml
  # ---------------------------------------------
  # show
  #
  # ---------------------------------------------
  def show
    @family_alias = FamilyAlias.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @family_alias }
    end
  end

  # GET /family_aliases/new
  # GET /family_aliases/new.xml
  # ---------------------------------------------
  # new
  #
  # ---------------------------------------------
  def new
    @family_alias = FamilyAlias.new
    @membid = params[ :membid ] if params[ :membid ]
    @name = params[ :name ] if params[ :name ]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @family_alias }
    end
  end  #  new
  # GET /family_aliases/1/edit
  # ---------------------------------------------
  # edit
  #
  # ---------------------------------------------
  def edit
    @family_alias = FamilyAlias.find(params[:id])
    # @family_alias.membid = @family_alias.id if !@family_alias.membid
    @old_alias = @family_alias.alias_name
  end  #  edit
  # POST /family_aliases
  # POST /family_aliases.xml
  # ---------------------------------------------
  # create
  #
  # Rev. 09/04/2012 to require general_helpers_201207
  # ---------------------------------------------
  def create
    require 'general_helpers_201207'
    @family_alias = FamilyAlias.new(params[:family_alias])
    #  puts "@family_alias is #{ @family_alias.inspect }"
    respond_to do |format|
      # do update here
      @family_alias.alias_hash5 = @family_alias[ :alias_name ].my_string_hash( 5 ) if 
          @family_alias[ :alias_name ].class == String
      if @family_alias.save
        flash[:notice] = @family_alias[ :type_of_name ].to_s + " '" + 
            @family_alias[ :alias_name ].to_s + "' as alternate name for '" +
            @family_alias[ :name ].to_s + "' entered."
        #  format.html { redirect_to(@family_alias) }
          format.html { redirect_to(url_for( :controller => 'family_data', 
              :action => 'tree', :id => @family_alias[ :membid ] ) ) }
        format.xml  { render :xml => @family_alias, :status => :created, :location => @family_alias }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @family_alias.errors, :status => :unprocessable_entity }
      end
    end
  end  #  create
  # PUT /family_aliases/1
  # PUT /family_aliases/1.xml
  # ---------------------------------------------
  # update
  #
  # Rev. 07/19/2012 to tweak @offset calculation and create method prep_nav_values
  # ---------------------------------------------
  def update
    require 'general_helpers_201207'
    @family_alias = FamilyAlias.find(params[:id])

    respond_to do |format|
      if @family_alias.update_attributes(params[:family_alias])
        flash[:notice] = 'FamilyAlias was successfully updated.'
        @family_alias.alias_hash5 = @family_alias.alias_name.my_string_hash( 5 )
        @family_alias.save
        @family_alias.reload
        #  puts "for " + @family_datum.name + ", hash5 is " + @family_datum.hash5
        format.html { redirect_to(@family_alias) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @family_alias.errors, :status => :unprocessable_entity }
      end
    end
  end  #  update

  # DELETE /family_aliases/1
  # DELETE /family_aliases/1.xml
  # ---------------------------------------------
  # destroy
  #
  # ---------------------------------------------
  def destroy
    @family_alias = FamilyAlias.find(params[:id])
    @family_alias.destroy

    respond_to do |format|
      format.html { redirect_to(family_aliases_url) }
      format.xml  { head :ok }
    end
  end  #  destroy
end
