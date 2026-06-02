class PasswordsController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_password_path, alert: "Try again later." }

  # Avant le edit ou update on execute le :set_password_reset_by_token donc le @passweord_reset : existe deja dans le edit et update
  before_action  :set_password_reset_by_token, only: [:edit, :update]

  def new
  end

  #lors de la creation (demande de reset )
  def create
    #on recherche l'utilisateur en bd (dans la table user)
    user = User.find_by(email: params[:email])

    # Si sont email est present, 
    if user 
      #On fait la creation d'une demande de reset relier a l'utilisateur dans la BD 
      password_reset = user.password_resets.create!(
        request_ip: request.remote_ip,
        user_agent: request.user_agent
      )

      # ON envoye par le PasswordsMailer une demande pour l'utilisateur  contenant le token 
      # Le deliver_later permet de mettre un travcailleur sur la request pour ne pas bloquer le HTTP 
      #
      #Pour l'instant on va utiliser la console pour tester aveant d'utiliser un vrai provider.
      #PasswordsMailer.reset(user,password_reset.raw_token).deliver_later

      Rails.logger.debug do
        "PASSWORD RESET LINK: #{edit_password_url(password_reset.raw_token)}"
      end

    end 

    # on Redirige vers la page new de session et on informe que ...
    redirect_to new_session_path, notice: "Si l'adress existe, un lien de réinitialisation a été envoyé."
  end

  # lorsque l'utilisateur clique sur le lien on verifie si le token est valide
  def edit
    redirect_to new_password_path, alert: "Lien de réinitialisation invalide ou expiré." unless @password_reset.usable?
  end

  #lorsqu'il submit le nouveau mot de passe 
  def update

    # ON verifier si le token est toujours valide 
    unless @password_reset.usable?
      redirect_to new_password_path, alert: "Lien de réinitialisation invalide ou expiré."
      return
    end

    #on assigne l'utilisateur 
    user = @password_reset.user

    #Je ne suis pas sur de moi mais je vais essayer ici 

    # une transaction permet qu'on recois plusieurs params simultanement mais que les deux doivent reussir pour que cela fonctionne
    ActiveRecord::Base.transaction do 
      #un update le mot de passe de l'utilisateur
      user.update!(password_params)

      #on update la table du password_reset pour mettre le token utiliser
      @password_reset.update!(reset_used_at: Time.current)

      #on detruit les sessions de l'utilisateur 
      user.sessions.destroy_all
    end

    # Message de validation 
    redirect_to new_password_path, notice: "Mot de passe réinitialisé. Connecte-toi avec ton nouveau mot de passe."

    # un rescue sur un enregistrement en bd qui est invalide
    rescue ActiveRecord::RecordInvalid
      redirect_to edit_password_path(params[:token]), alert: "Le mot de passe est invalide ou ne correspond pas à la confirmation."
  end

  private

    def set_password_reset_by_token
          
    # Hash du token
      # token_hash = Digest::SHA256.hexdigest(params[:token].to_s)
      # parce que la bd contient le hash du token 
      token_hash = Digest::SHA256.hexdigest(params[:token].to_s)

    # Recherche DB  selon le token_hash 
      # @password_reset = UserPasswordReset.unused.find_by(reset_token_hash: token_hash)
      # scope :unused, -> { where(reset_used_at: nil) }
      @password_reset = UserPasswordReset.unused.find_by(reset_token_hash: token_hash)
      
    # Protection securite
      # Si token introuvable on redirige

      unless @password_reset
        redirect_to new_password_path, alert: "Lien de réinitialisation invalide ou expiré."
      end
    end

    # les params qui seront retenu lors du post 
    def password_params
      params.permit(:password, :password_confirmation)
    end
end


