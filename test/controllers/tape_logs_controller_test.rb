require 'test_helper'

class TapeLogsControllerTest < ActionController::TestCase
  setup do
    @tape_log = tape_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tape_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tape_log" do
    assert_difference('TapeLog.count') do
      post :create, tape_log: { finish_at: @tape_log.finish_at, num: @tape_log.num, type: @tape_log.type }
    end

    assert_redirected_to tape_log_path(assigns(:tape_log))
  end

  test "should show tape_log" do
    get :show, id: @tape_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tape_log
    assert_response :success
  end

  test "should update tape_log" do
    patch :update, id: @tape_log, tape_log: { finish_at: @tape_log.finish_at, num: @tape_log.num, type: @tape_log.type }
    assert_redirected_to tape_log_path(assigns(:tape_log))
  end

  test "should destroy tape_log" do
    assert_difference('TapeLog.count', -1) do
      delete :destroy, id: @tape_log
    end

    assert_redirected_to tape_logs_path
  end
end
