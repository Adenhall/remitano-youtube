require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "registers new user when email does not exist" do
    assert_difference "User.count", 1 do
      post session_path, params: { email_address: "newuser@example.com", password: "Password1!" }
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

  test "home shares currentUser in Inertia props when logged in" do
    sign_in_as(@user)
    get root_path
    assert_equal @user.id, inertia.props[:currentUser][:id]
    assert_equal @user.email_address, inertia.props[:currentUser][:email]
  end

  test "home shares nil currentUser in Inertia props when logged out" do
    get root_path
    assert_nil inertia.props[:currentUser]
  end

  test "handles concurrent registration race condition gracefully" do
    email = "race@example.com"
    User.create!(email_address: email, password: "Password1!")

    # Simulate TOCTOU: find_by sees no user, but save hits a DB unique constraint
    # because another process inserted the row between the check and the insert.
    User.define_singleton_method(:find_by) { |*| nil }
    User.define_method(:save) { raise ActiveRecord::RecordNotUnique }
    begin
      assert_no_difference "User.count" do
        post session_path, params: { email_address: email, password: "password456" }
      end
      assert_redirected_to root_path
      assert_match(/log in/, flash[:alert])
    ensure
      User.singleton_class.remove_method(:find_by)
      User.remove_method(:save)
    end
  end
end
