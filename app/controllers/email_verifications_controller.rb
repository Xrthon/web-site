class EmailVerificationsController < ApplicationController
  allow_unauthenticated_access only: [:verify]

  def show
  end

  def create
    token = Current.user.email_verification_tokens.create!

    Rails.logger.debug "VERIFY EMAIL LINK: #{verify_email_url(token.raw_token)}"

    redirect_to email_verification_path,
                notice: "Lien généré. Regarde le terminal Rails."
  end

  def verify
    token_hash = Digest::SHA256.hexdigest(params[:token])

    verification_token = UserEmailVerificationToken.unused.find_by(token_hash: token_hash)

    if verification_token&.usable?
      # ici on veut que le token utilise et que le email arrive ensemble
      #Eviter les token utiliser mais email non verifier 
      verification_token.transaction do

        #ici on met le token consommer  
        verification_token.update!(used_at: Time.current)
        #email vérifié définitivement
        verification_token.user.update!(email_verified_at: Time.current)
      end

      #login automatique
      start_new_session_for(verification_token.user) unless authenticated?

      redirect_to new_profile_path,  notice: "Adresse courriel vérifiée."
    else
      redirect_to email_verification_path, alert: "Lien de vérification invalide ou expiré."
    end
  end
end
