class Admin::IdentityVerificationsController < Admin::BaseController
  def index
    @identity_verifications =
      UserIdentityVerification
        .includes(:user, :identity_verification_status)
        .order(created_at: :desc)
  end

  def show
    @identity_verification =
      UserIdentityVerification
        .includes(
          :user,
          :identity_verification_status,
          identity_documents: [
            :identity_document_type,
            :file_front,
            :file_back
          ]
        )
        .find(params[:id])
  end

  def approve
    verification = UserIdentityVerification.find(params[:id])
    approved_status = IdentityVerificationStatus.find_by!(code: "approved")

    verification.update!(
      identity_verification_status: approved_status,
      reviewed_by: Current.user.id,
      reviewed_at: Time.current,
      rejection_reason: nil
    )

    redirect_to admin_identity_verification_path(verification),
                notice: "Vérification approuvée."
  end

  def reject
    verification = UserIdentityVerification.find(params[:id])
    rejected_status = IdentityVerificationStatus.find_by!(code: "rejected")

    verification.update!(
      identity_verification_status: rejected_status,
      reviewed_by: Current.user.id,
      reviewed_at: Time.current,
      rejection_reason: params[:rejection_reason]
    )

    redirect_to admin_identity_verification_path(verification),
                notice: "Vérification refusée."
  rescue ActiveRecord::RecordInvalid
    redirect_to admin_identity_verification_path(verification),
                alert: "Une raison de refus est obligatoire."
  end
end