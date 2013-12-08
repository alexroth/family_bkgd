require 'test_helper'

class FamilyStartPointsControllerTest < ActionController::TestCase
  setup do
    @family_start_point = family_start_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:family_start_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create family_start_point" do
    assert_difference('FamilyStartPoint.count') do
      post :create, family_start_point: { comment: @family_start_point.comment, created_at: @family_start_point.created_at, family_descrip: @family_start_point.family_descrip, membid: @family_start_point.membid, updated_at: @family_start_point.updated_at }
    end

    assert_redirected_to family_start_point_path(assigns(:family_start_point))
  end

  test "should show family_start_point" do
    get :show, id: @family_start_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @family_start_point
    assert_response :success
  end

  test "should update family_start_point" do
    patch :update, id: @family_start_point, family_start_point: { comment: @family_start_point.comment, created_at: @family_start_point.created_at, family_descrip: @family_start_point.family_descrip, membid: @family_start_point.membid, updated_at: @family_start_point.updated_at }
    assert_redirected_to family_start_point_path(assigns(:family_start_point))
  end

  test "should destroy family_start_point" do
    assert_difference('FamilyStartPoint.count', -1) do
      delete :destroy, id: @family_start_point
    end

    assert_redirected_to family_start_points_path
  end
end
