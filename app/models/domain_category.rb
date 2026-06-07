class DomainCategory < ApplicationRecord

        # La meme categorie de domaine peut etre utiliser dans plusieur besoin de client
        # un ne veux pas supprimer une categorie de domaine s’il est déjà utilisé par des client_needs.
        has_many :domains, dependent: :restrict_with_error

        # il faut normaliser l'entrer du code pour eviter les erreurs de saisie et les doublons
        normalizes :code, with: ->(code) { code.strip.downcase}

        #il faut valider le code pour eviter les doublons et les erreurs de saisie
        validates :code, presence: true, uniqueness: true, length: { maximum: 50 }

        def translated_name
            I18n.t("domain_categories.#{code}")
        end 

end 