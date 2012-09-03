require 'test_helper'

class CollectDatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:collect_dates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create collect_date" do
    assert_difference('CollectDate.count') do
      post :create, :collect_date => { }
    end

    assert_redirected_to collect_date_path(assigns(:collect_date))
  end

  test "should show collect_date" do
    get :show, :id => collect_dates(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => collect_dates(:one).to_param
    assert_response :success
  end

  test "should update collect_date" do
    put :update, :id => collect_dates(:one).to_param, :collect_date => { }
    assert_redirected_to collect_date_path(assigns(:collect_date))
  end

  test "should destroy collect_date" do
    assert_difference('CollectDate.count', -1) do
      delete :destroy, :id => collect_dates(:one).to_param
    end

    assert_redirected_to collect_dates_path
  end
end
