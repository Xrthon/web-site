class UserIdentityDocument < ApplicationRecord
    belongs_to :user_identity_verification
    belongs_to :identity_document_type

    belongs_to :file_front, class_name: "UserFile"
    belongs_to :file_back, class_name: "UserFile", optional: true
    validates  :expires_at, presence: true, allow_nil: true

    validate :front_file_must_belong_to_same_user
    validate :back_file_must_belong_to_same_user

    private

    def front_file_must_belong_to_same_user
        return unless file_front

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
