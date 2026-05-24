class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def new
    redirect_to dashboard_path if authenticated?

    @user = User.new
  end

  def create
    service = Users::Register.new(user_params)
    @user = service.user

    if service.call
      start_new_session_for(@user)
      redirect_to new_profile_path, notice: "Compte créé avec succès."
    else
      flash.now[:alert] = "Veuillez corriger les erreurs."

      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :username,
      :email,
      :password,
      :password_confirmation
    )
  end
end