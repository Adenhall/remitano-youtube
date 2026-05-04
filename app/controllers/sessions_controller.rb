class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[create]
  rate_limit to: 10, within: 3.minutes, only: :create,
    with: -> { redirect_to root_path, alert: "Too many attempts. Try again later." }

  def create
    if (user = User.find_by(email_address: params[:email_address]))
      if (user = User.authenticate_by(params.permit(:email_address, :password)))
        start_new_session_for user
        redirect_to root_path, notice: "Logged in successfully."
      else
        redirect_to root_path, alert: "Invalid email or password."
      end
    else
      user = User.new(email_address: params[:email_address], password: params[:password])
      if user.save
        start_new_session_for user
        redirect_to root_path, notice: "Account created. Welcome!"
      else
        redirect_to root_path, alert: user.errors.full_messages.first
      end
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, status: :see_other
  end
end
