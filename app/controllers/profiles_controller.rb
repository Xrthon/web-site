class ProfilesController < ApplicationController
  def show
    @profile = Current.user.user_profile
  end

  def edit
    @profile = Current.user.user_profile
  end

  def update
    @profile = Current.user.user_profile

    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Profil mis à jour."
    else
      render :edit, status: :unprocessabl_entity
    end
  end

  private

  def profile_params
    params.require(:user_profile).permit(
      :first_name,
      :last_name,
      :display_name,
      :phone,
      :avatar_url,
      :language,
      :timezone,
      :country,
      :city,
      :theme_color
    )
  end
end
