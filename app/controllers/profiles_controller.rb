class ProfilesController < ApplicationController
  def show
    @profile = Current.user.user_profile
  end

  def new
    #important de mettre un return if sinon la fonction s'execute quand meme 
    redirect_to profile_path and return if Current.user.user_profile.present?

    @profile = Current.user.build_user_profile
  end
  def create
    redirect_to profile_path and return if Current.user.user_profile.present?

    @profile = Current.user.build_user_profile(profile_params)

    if @profile.save
      redirect_to dashboard_path, notice: "Profil complété."
    else
      flash.now[:alert] = "Veuillez corriger les erreurs."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @profile = Current.user.user_profile
  end

  def update
    @profile = Current.user.user_profile

    if @profile.update(profile_params)
      redirect_to dashboard_path, notice: "Profil mis à jour."
    else
      flash.now[:alert] = "Veuillez corriger les erreurs."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user_profile).permit(
      :display_name,
      :first_name,
      :last_name,
      :phone,
      :birth_date,
      :country,
      :city,
      :address_line1,
      :address_line2,
      :postal_code
    )
  end
end