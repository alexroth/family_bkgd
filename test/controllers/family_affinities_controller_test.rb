require 'test_helper'

class FamilyAffinitiesControllerTest < ActionController::TestCase
  setup do
    @family_affinity = family_affinities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:family_affinities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create family_affinity" do
    assert_difference('FamilyAffinity.count') do
      post :create, family_affinity: { comment: @family_affinity.comment, connection_membid: @family_affinity.connection_membid, connection_name: @family_affinity.connection_name, created_at: @family_affinity.created_at, membid: @family_affinity.membid, name: @family_affinity.name, other_type_value: @family_affinity.other_type_value, relationship: @family_affinity.relationship, updated_at: @family_affinity.updated_at }
    end

    assert_redirected_to family_affinity_path(assigns(:family_affinity))
  end

  test "should show family_affinity" do
    get :show, id: @family_affinity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @family_affinity
    assert_response :success
  end

  test "should update family_affinity" do
    patch :update, id: @family_affinity, family_affinity: { comment: @family_affinity.comment, connection_membid: @family_affinity.connection_membid, connection_name: @family_affinity.connection_name, created_at: @family_affinity.created_at, membid: @family_affinity.membid, name: @family_affinity.name, other_type_value: @family_affinity.other_type_value, relationship: @family_affinity.relationship, updated_at: @family_affinity.updated_at }
    assert_redirected_to family_affinity_path(assigns(:family_affinity))
  end

  test "should destroy family_affinity" do
    assert_difference('FamilyAffinity.count', -1) do
      delete :destroy, id: @family_affinity
    end

    assert_redirected_to family_affinities_path
  end
end
