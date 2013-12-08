require 'test_helper'

class FamilyDataControllerTest < ActionController::TestCase
  setup do
    @family_datum = family_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:family_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create family_datum" do
    assert_difference('FamilyDatum.count') do
      post :create, family_datum: { birth_date: @family_datum.birth_date, birth_place: @family_datum.birth_place, comment: @family_datum.comment, created_at: @family_datum.created_at, father: @family_datum.father, fatherid: @family_datum.fatherid, gender: @family_datum.gender, hash5: @family_datum.hash5, membid: @family_datum.membid, mother: @family_datum.mother, motherid: @family_datum.motherid, name: @family_datum.name, override_year: @family_datum.override_year, updated_at: @family_datum.updated_at }
    end

    assert_redirected_to family_datum_path(assigns(:family_datum))
  end

  test "should show family_datum" do
    get :show, id: @family_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @family_datum
    assert_response :success
  end

  test "should update family_datum" do
    patch :update, id: @family_datum, family_datum: { birth_date: @family_datum.birth_date, birth_place: @family_datum.birth_place, comment: @family_datum.comment, created_at: @family_datum.created_at, father: @family_datum.father, fatherid: @family_datum.fatherid, gender: @family_datum.gender, hash5: @family_datum.hash5, membid: @family_datum.membid, mother: @family_datum.mother, motherid: @family_datum.motherid, name: @family_datum.name, override_year: @family_datum.override_year, updated_at: @family_datum.updated_at }
    assert_redirected_to family_datum_path(assigns(:family_datum))
  end

  test "should destroy family_datum" do
    assert_difference('FamilyDatum.count', -1) do
      delete :destroy, id: @family_datum
    end

    assert_redirected_to family_data_path
  end
end
