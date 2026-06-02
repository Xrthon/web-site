class UserIdentityVerification < ApplicationRecord
    belongs_to :user

    belongs_to :identity_verification_status

    belongs_to :reviewer, class_name: "User", foreign_key: :reviewed_by, optional: true

    has_many  :identity_documents, class_name: "UserIdentityDocument", dependent: :destroy

    validates :user_id, uniqueness: true

    validates :rejection_reason, presence: true, if: :rejected?

   def pending?
    identity_verification_status.code == "pending"
  end

  def approved?
    identity_verification_status.code == "approved"
  end

  def rejected?
    identity_verification_status.code == "rejected"
  end

  def expired?
    identity_verification_status.code == "expired"
  end
end
