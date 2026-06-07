class Domain < ApplicationRecord

    # Un domain possede une seule categorie de domaine, mais un domain peut etre associe a plusieurs besoins de client
    belongs_to :domain_category
    
    has_many :client_needs, dependent: :restrict_with_error
    has_many :domain_tasks, dependent: :restrict_with_error
    
    # la normalisation du code pour eviter les erreurs de saisie et les doublons
    normalizes :code, with: ->(code) { code.strip.downcase }

    # validation du domain pour eviter les doublons et les erreurs de saisie
    validates :code, presence: true, uniqueness: {scope: :domain_category_id}, length: { maximum: 50 }

    def translated_name
        I18n.t("domains.#{code}")
    end
end