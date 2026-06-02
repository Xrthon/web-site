class IdentityVerificationStatus < ApplicationRecord
    has_many :user_identity_verifications, dependent: :restrict_with_error

    validates :code, presence: true, uniqueness: true, lenght: { maximum: 50 }

    normalizes :code, with: ->(code) { code.strip.downcase }

    def translated_name
        I18n.t("identity_verification_statuses.#{code}")
    end
end
