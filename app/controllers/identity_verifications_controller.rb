class IdentityVerificationsController < ApplicationController
  def show
    @identity_verification = Current.user.identity_verification
  end

  def new
    @document_types = IdentityDocumentType.all
  end

  def create
    pending_status = IdentityVerificationStatus.find_by!(code: "pending")
    document_type = IdentityDocumentType.find(params[:identity_document_type_id])

    ActiveRecord::Base.transaction do 
      verification = Current.user.identity_verification || Current.user.create_identity_verification!( identity_verification_status: pending_status)
      
      front_file = UserFileUploadService.new(
        user: Current.user,
        uploaded_file: params[:file_front],
        category_code: "identity_document",
        request_ip: request.remote_ip
      ).call

      back_file = nil

      if params[:file_back].present?
        back_file = UserFileUploadService.new(
          user: Current.user, 
          uploaded_file: params[:file_back],
          category_code: "identity_document",
          request_ip: request.remote_ip
        ).call
      end

      verification.identity_documents.create!(
        identity_document_type: document_type,
        file_front: front_file,
        file_back: back_file,
        expires_at: params[:expires_at]
      )
    end

    redirect_to identity_verification_path, notice: "Document envoye. Votre verification est en attente."

  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ArgumentError=> e
    @document_types = IdentityDocumentType.all
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_entity
  end
end
