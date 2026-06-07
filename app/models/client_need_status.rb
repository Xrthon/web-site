class ClientNeedStatus < ApplicationRecord

    # Un même statut de besoin client peut être utilisé par plusieurs besoins clients
  has_many :client_needs, dependent: :restrict_with_exception

  # Le code identifie le statut du besoin client dans le système.
  normalizes :code, with: ->(code) { code.strip.downcase }
    # Validation du code pour éviter les doublons et les erreurs de saisie.
  validates :code, presence: true, uniqueness: true, length: { maximum: 50 }

    # Retourne le nom traduit du statut du besoin client avec I18n.
    def translated_name
        I18n.t("client_need_statuses.#{code}")
    end 
    
end