require 'test_helper'

class DtcsControllerTest < ActionController::TestCase
  setup do
    @dtc = dtcs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dtcs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dtc" do
    assert_difference('Dtc.count') do
      post :create, dtc: { code: @dtc.code, description: @dtc.description, meaning: @dtc.meaning, source: @dtc.source }
    end

    assert_redirected_to dtc_path(assigns(:dtc))
  end

  test "should show dtc" do
    get :show, id: @dtc
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dtc
    assert_response :success
  end

  test "should update dtc" do
    patch :update, id: @dtc, dtc: { code: @dtc.code, description: @dtc.description, meaning: @dtc.meaning, source: @dtc.source }
    assert_redirected_to dtc_path(assigns(:dtc))
  end

  test "should destroy dtc" do
    assert_difference('Dtc.count', -1) do
      delete :destroy, id: @dtc
    end

    assert_redirected_to dtcs_path
  end
end
