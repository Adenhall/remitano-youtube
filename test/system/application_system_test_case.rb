require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  setup do
    # async adapter runs in-process so broadcasts reach the browser during system tests
    ActionCable.server.config.cable = { "adapter" => "async" }
  end

  private

  def sign_in_as(user)
    visit root_path
    find("input[type='email']").set(user.email_address)
    find("input[type='password']").set("password")
    click_button "Login / Register"
    assert_text "Welcome #{user.email_address}", wait: 5
  end
end
