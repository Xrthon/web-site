class Admin::DashboardController < Admin::BaseController
  def show
    @pending_identity_verifications =
      UserIdentityVerification
        .joins(:identity_verification_status)
        .where(identity_verification_statuses: { code: "pending" })
        .count
  end
end