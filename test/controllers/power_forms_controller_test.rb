require 'test_helper'

class PowerFormsControllerTest < ActionController::TestCase
  setup do
    @power_form = power_forms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:power_forms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create power_form" do
    assert_difference('PowerForm.count') do
      post :create, power_form: { appliance: @power_form.appliance, tend: @power_form.tend, tstart: @power_form.tstart }
    end

    assert_redirected_to power_form_path(assigns(:power_form))
  end

  test "should show power_form" do
    get :show, id: @power_form
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @power_form
    assert_response :success
  end

  test "should update power_form" do
    patch :update, id: @power_form, power_form: { appliance: @power_form.appliance, tend: @power_form.tend, tstart: @power_form.tstart }
    assert_redirected_to power_form_path(assigns(:power_form))
  end

  test "should destroy power_form" do
    assert_difference('PowerForm.count', -1) do
      delete :destroy, id: @power_form
    end

    assert_redirected_to power_forms_path
  end
end
