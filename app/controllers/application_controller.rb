class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: :modern

  inertia_share do
    {
      currentUser: Current.user&.then { |u| { id: u.id, email: u.email_address } },
      flash: flash.to_h
    }
  end

  private

  def request_authentication
    redirect_to root_path, alert: "Please log in to continue."
  end
end
