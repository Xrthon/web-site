class Admin::UserFilesController < Admin::BaseController
    def show 
        user_file = UserFile.find(params[:id])


        full_path = Rails.root.join("storage", user_file.storage_key)

        unless File.exist?(full_path)
            redirect_back fallback_location: admin_identity_verifications_path, alert: "Fichier introuvable."
            return
        end

        send_file full_path, 
            filename: user_file.original_filename,
            type: user_file.mime_type,
            disposition: "inline"
    end
end