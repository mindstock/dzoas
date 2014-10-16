require 'test_helper'

class PowersControllerTest < ActionController::TestCase
  setup do
    @power = powers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:powers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create power" do
    assert_difference('Power.count') do
      post :create, power: { name: @power.name, parent_id: @power.parent_id, remark: @power.remark, url: @power.url }
    end

    assert_redirected_to power_path(assigns(:power))
  end

  test "should show power" do
    get :show, id: @power
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @power
    assert_response :success
  end

  test "should update power" do
    patch :update, id: @power, power: { name: @power.name, parent_id: @power.parent_id, remark: @power.remark, url: @power.url }
    assert_redirected_to power_path(assigns(:power))
  end

  test "should destroy power" do
    assert_difference('Power.count', -1) do
      delete :destroy, id: @power
    end

    assert_redirected_to powers_path
  end
end
