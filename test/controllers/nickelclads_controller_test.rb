require 'test_helper'

class NickelcladsControllerTest < ActionController::TestCase
  setup do
    @nickelclad = nickelclads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nickelclads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nickelclad" do
    assert_difference('Nickelclad.count') do
      post :create, nickelclad: { allowance: @nickelclad.allowance, is_declicacy: @nickelclad.is_declicacy, length: @nickelclad.length, thickness: @nickelclad.thickness, to: @nickelclad.to, wide: @nickelclad.wide }
    end

    assert_redirected_to nickelclad_path(assigns(:nickelclad))
  end

  test "should show nickelclad" do
    get :show, id: @nickelclad
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nickelclad
    assert_response :success
  end

  test "should update nickelclad" do
    patch :update, id: @nickelclad, nickelclad: { allowance: @nickelclad.allowance, is_declicacy: @nickelclad.is_declicacy, length: @nickelclad.length, thickness: @nickelclad.thickness, to: @nickelclad.to, wide: @nickelclad.wide }
    assert_redirected_to nickelclad_path(assigns(:nickelclad))
  end

  test "should destroy nickelclad" do
    assert_difference('Nickelclad.count', -1) do
      delete :destroy, id: @nickelclad
    end

    assert_redirected_to nickelclads_path
  end
end
