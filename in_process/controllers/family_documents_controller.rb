class FamilyDocumentsController < ApplicationController
  # GET /family_documents
  # GET /family_documents.xml
  # ---------------------------------------------
  # index
  # Rev. 06/27/2012 to tweak @offset calculation and create method prep_nav_values
  # ---------------------------------------------
  def index
    require 'general_helpers_201207'
    @table_count = FamilyDocument.count
    prep_nav_values( params )
    @family_documents = FamilyDocument.find( :all, :offset => @offset, :limit => @max_rows )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @family_documents }
    end
  end

  # GET /family_documents/1
  # GET /family_documents/1.xml
  def show
    @family_document = FamilyDocument.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @family_document }
    end
  end

  # GET /family_documents/new
  # GET /family_documents/new.xml
  def new
    @family_document = FamilyDocument.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @family_document }
    end
  end

  # GET /family_documents/1/edit
  def edit
    @family_document = FamilyDocument.find(params[:id])
  end

  # POST /family_documents
  # POST /family_documents.xml
  def create
    @family_document = FamilyDocument.new(params[:family_document])

    respond_to do |format|
      if @family_document.save
        flash[:notice] = 'FamilyDocument was successfully created.'
        #  format.html { redirect_to(@family_document) }
        format.html { redirect_to(url_for( :controller => 'family_data', 
              :action => 'tree', :id => @family_document[ :membid ] ) ) }

        format.xml  { render :xml => @family_document, :status => :created, :location => @family_document }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @family_document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /family_documents/1
  # PUT /family_documents/1.xml
  def update
    @family_document = FamilyDocument.find(params[:id])

    respond_to do |format|
      if @family_document.update_attributes(params[:family_document])
        flash[:notice] = 'FamilyDocument was successfully updated.'
        format.html { redirect_to(@family_document) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @family_document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /family_documents/1
  # DELETE /family_documents/1.xml
  def destroy
    @family_document = FamilyDocument.find(params[:id])
    @family_document.destroy

    respond_to do |format|
      format.html { redirect_to(family_documents_url) }
      format.xml  { head :ok }
    end
  end
end
