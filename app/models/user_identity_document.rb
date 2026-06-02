class UserIdentityDocument < ApplicationRecord
    # Le document appartient à une demande de vérification d'identité
    belongs_to :user_identity_verification

    # Le document possède un type.
    belongs_to :identity_document_type

    # Fichier du recto du document.
    belongs_to :file_front, class_name: "UserFile"

    # Fichier du verso du document.
    belongs_to :file_back, class_name: "UserFile", optional: true

    # Date d'expiration du document.
    validates  :expires_at, presence: true, allow_nil: true

    # Sécurité :
        # on vérifie que les fichiers liés appartiennent au même utilisateur
        # que la demande de vérification.
    validate :front_file_must_belong_to_same_user
    validate :back_file_must_belong_to_same_user

    private

    def front_file_must_belong_to_same_user
        return unless file_front

        # on assure que le user_file est le meme id que le user_identity_verification
        if file_front.user_id != user_identity_verification.user_id
            errors.add(:file_front, "doit appartenir au même  utilisateur")
        end
    end

    def back_file_must_belong_to_same_user
        return unless file_back

        if file_back.user_id != user_identity_verification.user_id
            errors.add(:file_back, "doit appartenir au même  utilisateur")
        end
    end

end
