class Client::NeedsController < ApplicationController
    before_action :require_client

    
    # Présente un besoin client spécifique 
    def show
        
    end 

    # Présente  de la liste de besoin créer par le client
    def index
    
    end 

    # Présente le formulaire pour la création d' un besoin 
    def new 
        # on doit d'abord construire le besion 
        @client_need = Current.user.client_needs.build

        # on donne acces au domain et c'est categories
        @domain_categories = DomainCategory.includes(domains: :domain_tasks)
        
        # On charge les services location types
        @service_location_types = ServiceLocationType.all

    end 

    # Valide le besoin reçu et créer un nouveau besoin
    def create

    end 

    # Presentation du formulaire pour l'edition d'un besoin
    def edit

    end 

    # Valide les modifications et met à jour le besoin
    def update

    end 

    # Supprime un besoin 
    def destroy
        
    end 

    private 

    # Vérifie que l'utilisateur possède le rôle client
    def require_client
        return if Current.user&.roles.exists?(code: "client")

        redirect_to root_path, alert: "Accès refusé."
    end 

    def needs_params 
    
    end 
end