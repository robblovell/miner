require 'test_helper'

class CapstonesControllerTest < ActionController::TestCase
  setup do
    @capstone = capstones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:capstones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create capstone" do
    assert_difference('Capstone.count') do
      post :create, capstone: { index: @capstone.index, number: @capstone.number }
    end

    assert_redirected_to capstone_path(assigns(:capstone))
  end

  test "should show capstone" do
    get :show, id: @capstone
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @capstone
    assert_response :success
  end

  test "should update capstone" do
    patch :update, id: @capstone, capstone: { index: @capstone.index, number: @capstone.number }
    assert_redirected_to capstone_path(assigns(:capstone))
  end

  test "should destroy capstone" do
    assert_difference('Capstone.count', -1) do
      delete :destroy, id: @capstone
    end

    assert_redirected_to capstones_path
  end
end
