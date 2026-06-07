class ServiceLocationType < ApplicationRecord

    # Un meme type de service peut se retrouver dans plusieurs demande de service
    # Comme c’est un lookup, tu ne veux pas supprimer un ServiceLocationType s’il est déjà utilisé par des client_needs.
    has_many :client_needs, dependent: :restrict_with_error


    # Il faut normaliser le code avant de le sauvegarder pour éviter les erreurs et
    normalizes :code, with: ->(code) { code.strip.downcase }

    # Il faut valider le code recu pour eviter les doublons et les erreurs de saisie
    # On le compare avec les autres codes de la base de données pour assurer l'unicité
    validates :code, presence: true, uniqueness: true, length: { maximum: 50 }

    #Retourne le nom traduit du type de service avec I18n
    def translated_name
        I18n.t("service_location_types.#{code}")
    end


end