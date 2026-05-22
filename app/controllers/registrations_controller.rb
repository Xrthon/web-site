class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def new
    redirect_to dashboard_path if authenticated?
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to new_session_path, notice: "Compte créé. Connecte-toi."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email_address,
      :username,
      :password,
      :password_confirmation
    )
  end
end