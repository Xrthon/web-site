class PagesController< ApplicationController

  #permet d'activier les visiteurs  non connecter sur certaine page 
  allow_unauthenticated_access only: :home

  def home
    # Si nous somme connecter et que nous voulons que la page d'accueil d'un utilisateur connecter soit différente de cel d'un utilisateur déconnecter 
        # il faut simplement faire un redirect_to
        # authenticated? signifie si quelqu'un est connecter 
        # aller voir dasn controllers/concerns/authentication.rb pour voir les methode déjà implementer !
    redirect_to dashboard_path if authenticated?
  end


  #ce que les utilisateur vont voir quand il seront connecter
  def dashboard
    redirect_to new_session_path unless authenticated?
  end



end
