require 'test_helper'

class CommandsControllerTest < ActionController::TestCase
  setup do
    @command = commands(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:commands)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create command" do
    assert_difference('Command.count') do
      post :create, command: { content: @command.content, fb_id: @command.fb_id, fb_name: @command.fb_name, picture_id: @command.picture_id }
    end

    assert_redirected_to command_path(assigns(:command))
  end

  test "should show command" do
    get :show, id: @command
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @command
    assert_response :success
  end

  test "should update command" do
    put :update, id: @command, command: { content: @command.content, fb_id: @command.fb_id, fb_name: @command.fb_name, picture_id: @command.picture_id }
    assert_redirected_to command_path(assigns(:command))
  end

  test "should destroy command" do
    assert_difference('Command.count', -1) do
      delete :destroy, id: @command
    end

    assert_redirected_to commands_path
  end
end
