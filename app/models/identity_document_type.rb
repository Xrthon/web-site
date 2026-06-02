class IdentityDocumentType < ApplicationRecord
    # Un même type de document peut être utilisé par plusieurs documents soumis
    has_many :user_identity_documents, dependent: :restrict_with_error

    # Le code identifie le type de document dans le système.
    validates :expires_at, presence: true

    # Nettoie le code avant sauvegarde.
    normalizes :code, with: ->(code) { code.strip.downcase}


    # Retourne le nom traduit du type de document avec I18n.
    def translated_name
        I18n.t("identity_document_types.#{code}")
    end
end
