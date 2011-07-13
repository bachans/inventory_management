require 'test_helper'

class PrivateOrdersControllerTest < ActionController::TestCase
  setup do
    @private_order = private_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:private_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create private_order" do
    assert_difference('PrivateOrder.count') do
      post :create, :private_order => @private_order.attributes
    end

    assert_redirected_to private_order_path(assigns(:private_order))
  end

  test "should show private_order" do
    get :show, :id => @private_order.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @private_order.to_param
    assert_response :success
  end

  test "should update private_order" do
    put :update, :id => @private_order.to_param, :private_order => @private_order.attributes
    assert_redirected_to private_order_path(assigns(:private_order))
  end

  test "should destroy private_order" do
    assert_difference('PrivateOrder.count', -1) do
      delete :destroy, :id => @private_order.to_param
    end

    assert_redirected_to private_orders_path
  end
end
