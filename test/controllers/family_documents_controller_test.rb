require 'test_helper'

class FamilyDocumentsControllerTest < ActionController::TestCase
  setup do
    @family_document = family_documents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:family_documents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create family_document" do
    assert_difference('FamilyDocument.count') do
      post :create, family_document: { comment: @family_document.comment, created_at: @family_document.created_at, doc_descrip: @family_document.doc_descrip, doc_link: @family_document.doc_link, doc_type: @family_document.doc_type, event_date: @family_document.event_date, event_place: @family_document.event_place, event_type: @family_document.event_type, membid: @family_document.membid, name: @family_document.name, other_doc_type: @family_document.other_doc_type, other_event_type: @family_document.other_event_type, other_place_type: @family_document.other_place_type, place_type: @family_document.place_type, updated_at: @family_document.updated_at }
    end

    assert_redirected_to family_document_path(assigns(:family_document))
  end

  test "should show family_document" do
    get :show, id: @family_document
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @family_document
    assert_response :success
  end

  test "should update family_document" do
    patch :update, id: @family_document, family_document: { comment: @family_document.comment, created_at: @family_document.created_at, doc_descrip: @family_document.doc_descrip, doc_link: @family_document.doc_link, doc_type: @family_document.doc_type, event_date: @family_document.event_date, event_place: @family_document.event_place, event_type: @family_document.event_type, membid: @family_document.membid, name: @family_document.name, other_doc_type: @family_document.other_doc_type, other_event_type: @family_document.other_event_type, other_place_type: @family_document.other_place_type, place_type: @family_document.place_type, updated_at: @family_document.updated_at }
    assert_redirected_to family_document_path(assigns(:family_document))
  end

  test "should destroy family_document" do
    assert_difference('FamilyDocument.count', -1) do
      delete :destroy, id: @family_document
    end

    assert_redirected_to family_documents_path
  end
end
