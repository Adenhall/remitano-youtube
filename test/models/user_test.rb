require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal "downcased@example.com", user.email_address
  end

  test "requires email_address" do
    user = User.new(password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "rejects duplicate email_address" do
    existing = users(:one)
    user = User.new(email_address: existing.email_address, password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "rejects duplicate email_address case-insensitively" do
    existing = users(:one)
    user = User.new(email_address: existing.email_address.upcase, password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "requires password" do
    user = User.new(email_address: "new@example.com")
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end
end
