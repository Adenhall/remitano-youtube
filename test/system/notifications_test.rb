require_relative "../system/application_system_test_case"

class NotificationsTest < ApplicationSystemTestCase
  PAYLOAD = { title: "Live Test Video Title", shared_by: "two@example.com" }.freeze

  test "shows notification banner when another user shares a video" do
    sign_in_as users(:one)
    visit root_path

    ActionCable.server.broadcast("notifications", PAYLOAD)

    assert_selector "[role='alert']", wait: 3
    within("[role='alert']") do
      assert_text "Live Test Video Title"
      assert_text "two@example.com"
    end
  end

  test "notification banner can be dismissed" do
    sign_in_as users(:one)
    visit root_path

    ActionCable.server.broadcast("notifications", PAYLOAD)

    assert_selector "[role='alert']", wait: 5
    page.execute_script("document.querySelector(\"button[aria-label='Dismiss notification']\").click()")
    assert_no_selector "[role='alert']", wait: 5
  end

  test "sharer does not see notification for their own video" do
    sign_in_as users(:one)
    visit root_path

    ActionCable.server.broadcast("notifications", {
      title: "Live Test Video Title",
      shared_by: users(:one).email_address
    })

    assert_no_selector "[role='alert']", wait: 2
  end
end
