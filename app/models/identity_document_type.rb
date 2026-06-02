class IdentityDocumentType < ApplicationRecord

    has_many :user_identity_documents, dependent: :restrict_with_error

    validate :code, presence: true, uniqueness: true, lenght: { maximum: 50 }

    normalizes :code, with: ->(code) { code.strip.downcase}

    def translated_name
        I18n.t("identity_document_types.#{code}")
    end
end
