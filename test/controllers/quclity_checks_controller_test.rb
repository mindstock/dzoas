require 'test_helper'

class QuclityChecksControllerTest < ActionController::TestCase
  setup do
    @quclity_check = quclity_checks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quclity_checks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quclity_check" do
    assert_difference('QuclityCheck.count') do
      post :create, quclity_check: { is_standard: @quclity_check.is_standard, remark: @quclity_check.remark }
    end

    assert_redirected_to quclity_check_path(assigns(:quclity_check))
  end

  test "should show quclity_check" do
    get :show, id: @quclity_check
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quclity_check
    assert_response :success
  end

  test "should update quclity_check" do
    patch :update, id: @quclity_check, quclity_check: { is_standard: @quclity_check.is_standard, remark: @quclity_check.remark }
    assert_redirected_to quclity_check_path(assigns(:quclity_check))
  end

  test "should destroy quclity_check" do
    assert_difference('QuclityCheck.count', -1) do
      delete :destroy, id: @quclity_check
    end

    assert_redirected_to quclity_checks_path
  end
end
