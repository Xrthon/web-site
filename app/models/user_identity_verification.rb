class UserIdentityVerification < ApplicationRecord

    # La vérification appartient à un utilisateur.
    belongs_to :user

    # La vérification possède un statut.
    belongs_to :identity_verification_status
    
    # L'admin ou l'employé qui a révisé la vérification.
    # C'est aussi un User, mais avec un rôle différent.
    # optional: true parce qu'au début la demande n'est pas encore révisée.
    belongs_to :reviewer, class_name: "User", foreign_key: :reviewed_by, optional: true

    # Une vérification peut contenir plusieurs documents.
    has_many  :identity_documents, class_name: "UserIdentityDocument", dependent: :destroy

    # Assure qu'un utilisateur n'a qu'une seule ligne
    validates :user_id, uniqueness: true

    # Si la vérification est rejetée, une raison est obligatoire.
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
