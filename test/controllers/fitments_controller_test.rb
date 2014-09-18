require 'test_helper'

class FitmentsControllerTest < ActionController::TestCase
  setup do
    @fitment = fitments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fitments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fitment" do
    assert_difference('Fitment.count') do
      post :create, fitment: { engine: @fitment.engine, make: @fitment.make, model: @fitment.model, year: @fitment.year }
    end

    assert_redirected_to fitment_path(assigns(:fitment))
  end

  test "should show fitment" do
    get :show, id: @fitment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fitment
    assert_response :success
  end

  test "should update fitment" do
    patch :update, id: @fitment, fitment: { engine: @fitment.engine, make: @fitment.make, model: @fitment.model, year: @fitment.year }
    assert_redirected_to fitment_path(assigns(:fitment))
  end

  test "should destroy fitment" do
    assert_difference('Fitment.count', -1) do
      delete :destroy, id: @fitment
    end

    assert_redirected_to fitments_path
  end
end
