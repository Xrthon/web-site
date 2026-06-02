class IdentityVerificationStatus < ApplicationRecord
    # Un même statut peut être utilisé par plusieurs vérifications.
    has_many :user_identity_verifications, dependent: :restrict_with_error

    # Le code identifie le statut dans le système.
    validates :code, presence: true, uniqueness: true, length: { maximum: 50 }

    # Nettoie le code avant sauvegarde.
    normalizes :code, with: ->(code) { code.strip.downcase }

    # Retourne le nom traduit du statut avec I18n.
    def translated_name
        I18n.t("identity_verification_statuses.#{code}")
    end
end
