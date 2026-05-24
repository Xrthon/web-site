class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(login_params)
      start_new_session_for user
      redirect_to root_path, notice: "Connexion réussie!"
    else
      flash.now[:alert] = "Adresse courriel ou mot de passe invalide."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
