class FamilyDocumentsController < ApplicationController
  before_action :set_family_document, only: [:show, :edit, :update, :destroy]

  # GET /family_documents
  # GET /family_documents.json
  def index
    @family_documents = FamilyDocument.all
  end

  # GET /family_documents/1
  # GET /family_documents/1.json
  def show
  end

  # GET /family_documents/new
  def new
    @family_document = FamilyDocument.new
  end

  # GET /family_documents/1/edit
  def edit
  end

  # POST /family_documents
  # POST /family_documents.json
  def create
    @family_document = FamilyDocument.new(family_document_params)

    respond_to do |format|
      if @family_document.save
        format.html { redirect_to @family_document, notice: 'Family document was successfully created.' }
        format.json { render action: 'show', status: :created, location: @family_document }
      else
        format.html { render action: 'new' }
        format.json { render json: @family_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /family_documents/1
  # PATCH/PUT /family_documents/1.json
  def update
    respond_to do |format|
      if @family_document.update(family_document_params)
        format.html { redirect_to @family_document, notice: 'Family document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @family_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /family_documents/1
  # DELETE /family_documents/1.json
  def destroy
    @family_document.destroy
    respond_to do |format|
      format.html { redirect_to family_documents_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family_document
      @family_document = FamilyDocument.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_document_params
      params.require(:family_document).permit(:doc_descrip, :doc_type, :doc_link, :name, :membid, :comment, :created_at, :updated_at, :event_type, :event_date, :event_place, :place_type, :other_doc_type, :other_place_type, :other_event_type)
    end
end
