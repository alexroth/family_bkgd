require 'test_helper'

class FamilyAliasesControllerTest < ActionController::TestCase
  setup do
    @family_alias = family_aliases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:family_aliases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create family_alias" do
    assert_difference('FamilyAlias.count') do
      post :create, family_alias: { alias_hash5: @family_alias.alias_hash5, alias_name: @family_alias.alias_name, comment: @family_alias.comment, created_at: @family_alias.created_at, membid: @family_alias.membid, name: @family_alias.name, other_type_value: @family_alias.other_type_value, type_of_name: @family_alias.type_of_name, updated_at: @family_alias.updated_at }
    end

    assert_redirected_to family_alias_path(assigns(:family_alias))
  end

  test "should show family_alias" do
    get :show, id: @family_alias
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @family_alias
    assert_response :success
  end

  test "should update family_alias" do
    patch :update, id: @family_alias, family_alias: { alias_hash5: @family_alias.alias_hash5, alias_name: @family_alias.alias_name, comment: @family_alias.comment, created_at: @family_alias.created_at, membid: @family_alias.membid, name: @family_alias.name, other_type_value: @family_alias.other_type_value, type_of_name: @family_alias.type_of_name, updated_at: @family_alias.updated_at }
    assert_redirected_to family_alias_path(assigns(:family_alias))
  end

  test "should destroy family_alias" do
    assert_difference('FamilyAlias.count', -1) do
      delete :destroy, id: @family_alias
    end

    assert_redirected_to family_aliases_path
  end
end
