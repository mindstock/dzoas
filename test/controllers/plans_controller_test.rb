require 'test_helper'

class PlansControllerTest < ActionController::TestCase
  setup do
    @plan = plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plan" do
    assert_difference('Plan.count') do
      post :create, plan: { allowance: @plan.allowance, final_piece: @plan.final_piece, final_row: @plan.final_row, final_sheet: @plan.final_sheet, finish_at: @plan.finish_at, is_declicacy: @plan.is_declicacy, is_urgency: @plan.is_urgency, length: @plan.length, real_finish_at: @plan.real_finish_at, status: @plan.status, thickness: @plan.thickness, to: @plan.to, wide: @plan.wide }
    end

    assert_redirected_to plan_path(assigns(:plan))
  end

  test "should show plan" do
    get :show, id: @plan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @plan
    assert_response :success
  end

  test "should update plan" do
    patch :update, id: @plan, plan: { allowance: @plan.allowance, final_piece: @plan.final_piece, final_row: @plan.final_row, final_sheet: @plan.final_sheet, finish_at: @plan.finish_at, is_declicacy: @plan.is_declicacy, is_urgency: @plan.is_urgency, length: @plan.length, real_finish_at: @plan.real_finish_at, status: @plan.status, thickness: @plan.thickness, to: @plan.to, wide: @plan.wide }
    assert_redirected_to plan_path(assigns(:plan))
  end

  test "should destroy plan" do
    assert_difference('Plan.count', -1) do
      delete :destroy, id: @plan
    end

    assert_redirected_to plans_path
  end
end
