require 'test_helper'

class GarbagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:garbages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create garbage" do
    assert_difference('Garbage.count') do
      post :create, :garbage => { }
    end

    assert_redirected_to garbage_path(assigns(:garbage))
  end

  test "should show garbage" do
    get :show, :id => garbages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => garbages(:one).to_param
    assert_response :success
  end

  test "should update garbage" do
    put :update, :id => garbages(:one).to_param, :garbage => { }
    assert_redirected_to garbage_path(assigns(:garbage))
  end

  test "should destroy garbage" do
    assert_difference('Garbage.count', -1) do
      delete :destroy, :id => garbages(:one).to_param
    end

    assert_redirected_to garbages_path
  end
end
