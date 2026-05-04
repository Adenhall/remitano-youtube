require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "registers new user when email does not exist" do
    assert_difference "User.count", 1 do
      post session_path, params: { email_address: "newuser@example.com", password: "password123" }
    end
    assert_redirected_to root_path
    assert_not_nil cookies[:session_id]
  end

  test "logs in existing user with correct password" do
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_redirected_to root_path
    assert_not_nil cookies[:session_id]
  end

  test "rejects existing user with wrong password" do
    post session_path, params: { email_address: @user.email_address, password: "wrongpassword" }
    assert_redirected_to root_path
    assert_nil cookies[:session_id]
  end

  test "logout destroys session and redirects to root" do
    sign_in_as(@user)
    delete session_path
    assert_redirected_to root_path
    assert_empty cookies[:session_id]
  end

  test "home is accessible when not logged in" do
    get root_path
    assert_response :success
  end
end
