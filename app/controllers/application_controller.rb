class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :require_verified_email
  before_action :require_profile_completed


  private 


  def require_verified_email
    return unless authenticated?
    return if Current.user.email_verified_at.present?

    allowed_routes = (controller_name == "email_verifications" && ["show","create","verify"].include?(action_name)) || controller_name == "sessions" && ["destroy"].include?(action_name)

    return if allowed_routes
    redirect_to email_verification_path, alert: "Veuillez obligatoirement verifier votre email"

  end
  
  def require_profile_completed
    #s'il n'est pas authentifier on le laisse passer
    return unless authenticated?

    return unless Current.user.email_verified?
    return if Current.user.user_profile.present?
    
    #ici on autorise seulement le controler de profiles
    allowed_routes = (
      controller_name == "profiles" && 
      ["new", "create"].include?(action_name)
    )|| (
      controller_name == "sessions" && ["destroy"].include?(action_name)
    )
    #ici on permet de continuer sur le site si  il est dans le bon controller et s'il fait la bonne action
    return if allowed_routes
    redirect_to new_profile_path, alert: "Veuillez obligatoirement completer votre profile"
  end

end
