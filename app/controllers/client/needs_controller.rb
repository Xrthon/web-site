class Client::NeedsController < ApplicationController
    before_action :require_client
    
    #Ici nous allons chercher l'id du besoin 
    before_action :set_client_need, only: [:show, :edit, :update, :destroy]
    
    # Présente un besoin client spécifique 
    def show


        ############ Plus necessaire du a { before_action :set_client_need, only: [:show, :edit, :update, :destroy]} **************************************
        #Ici nous allons chercher l'id du besoin 
        # @client_need = Current.user.client_needs.find(params[:id])

    end 

    # Présente  de la liste de besoin créer par le client
    def index
        #Charger les besoins d'un client qui ce trouver en BD et en ordre de date de creation
        @client_needs = Current.user.client_needs.order(created_at: :desc)
    end 

    # Présente le formulaire pour la création d' un besoin 
    def new 
        # on doit d'abord construire le besion 
        @client_need = Current.user.client_needs.build
        # on construit ensuite l'item d'un besoin
        @client_need.client_need_items.build
        # on donne acces au domain et c'est categories
        @domain_categories = DomainCategory.includes(domains: :domain_tasks)
        
        # On charge les services location types
        @service_location_types = ServiceLocationType.all

    end 

    # Valide le besoin reçu et créer un nouveau besoin
    def create
        #Creation du besoin du client
        @client_need = Current.user.client_needs.build(client_needs_params)

        #On enregistre tente d'enregistrer en bd 
        if @client_need.save
            #On fait une redirection si le save fonction
            redirect_to client_needs_path, notice: "Votre demande est enregitré avec sucèss!"
        else
            # Il faut les recharger si le new echoue,car on renvoye les informations dans le formulaire
            @domain_categories = DomainCategory.includes(domains: :domain_tasks)
            @service_location_types = ServiceLocationType.all

            #Ici nous envoyons un message d'alerte si le save a pas reussi
            flash.now[:alert] = "Veuillez corriger les erreurs."
            #Nous renvoyons les params du new
            render :new, status: :unprocessable_entity
        end

    end 

    # Presentation du formulaire pour l'edition d'un besoin
    def edit
        ############ Plus necessaire du a { before_action :set_client_need, only: [:show, :edit, :update, :destroy]} **************************************
            #Ici nous allons chercher l'id du besoin 
            # @client_need = Current.user.client_needs.find(params[:id])
        
            # on construit ensuite l'item d'un besoin
        @client_need.client_need_items.build if @client_need.client_need_items.empty?
        # on donne acces au domain et c'est categories
        @domain_categories = DomainCategory.includes(domains: :domain_tasks)
        # On charge les services location types
        @service_location_types = ServiceLocationType.all

    end 

    # Valide les modifications et met à jour le besoin
    def update
        ############ Plus necessaire du a { before_action :set_client_need, only: [:show, :edit, :update, :destroy]} **************************************
            #Ici nous allons chercher l'id du besoin 
            # @client_need = Current.user.client_needs.find(params[:id])

         #On enregistre tente d'enregistrer en bd 
        if @client_need.update(client_needs_params)
            #On fait une redirection si le save fonction
            redirect_to client_need_path(@client_need), notice: "Votre demande a été modifiée avec succès!"
        else
            # Il faut les recharger si le new echoue,car on renvoye les informations dans le formulaire
            @domain_categories = DomainCategory.includes(domains: :domain_tasks)
            @service_location_types = ServiceLocationType.all

            #Ici nous envoyons un message d'alerte si le save a pas reussi
            flash.now[:alert] = "Veuillez corriger les erreurs."
            #Nous renvoyons les params du new
            render :edit, status: :unprocessable_entity
        end
    end 

    # Supprime un besoin 
    def destroy
        ############ Plus necessaire du a { before_action :set_client_need, only: [:show, :edit, :update, :destroy]} **************************************
            # Ici nous allons chercher l'id du besoin 
            # @client_need = Current.user.client_needs.find(params[:id])

       #il faut utilié destroye, car le delete supprime directement dans la BD sans se soucier des callback et tout...
       if @client_need.destroy
         #On fait une redirection si l'index  client_needs_path et non client_need_path(@client_need)
            redirect_to client_needs_path, notice: "Votre demande a été supprimé avec succès!"
       else
            #Ici nous envoyons un message d'alerte si le destroye a pas reussi
            flash.now[:alert] = "Impossible de supprimer cette demande."
            
            # Il faut les recharger si le destroy echoue,car on renvoye les informations dans le formulaire
            @domain_categories = DomainCategory.includes(domains: :domain_tasks)
            @service_location_types = ServiceLocationType.all

            render :edit, status: :unprocessable_entity
       end
    end 

    private 

    # Vérifie que l'utilisateur possède le rôle client
    def require_client
        return if Current.user&.roles.exists?(code: "client")

        redirect_to root_path, alert: "Accès refusé."
    end 


    def set_client_need
        @client_need = Current.user.client_needs.find(params[:id]) 
    end 


    def client_needs_params 
        params.require(:client_need).permit(
            :title,
            :domain_id,
            :service_location_type_id,
            :city,
            :province,
            :postal_code,
            :budget_min,
            :budget_max,
            :desired_date,
            :is_urgent,
            client_need_items_attributes: [
                :id,
                :title,
                :description,
                :quantity
            ]
        )
    end 
end