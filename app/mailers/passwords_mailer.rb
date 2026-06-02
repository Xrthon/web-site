class PasswordsMailer < ApplicationMailer
  def reset(user, raw_token)
    @user = user
    @raw_token = raw_token

    mail subject: "Réinitialisation de votre mot de passe", to: user.email
  end
end