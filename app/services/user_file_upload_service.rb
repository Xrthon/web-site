class UserFileUploadService

    #Taille maximale autorisee pour un upload
    MAX_FILE_SIZE = 10.megabytes

    #Types MIME autorises
    ALLOWED_MIME_TYPES = [
        "image/jpeg",
        "image/png",
        "application/pdf"
    ].freeze

    #Le service recoit: 
    #   - l"utilisateur
    #   - le fichier uploade
    #   - la categorie du fichier
    #   - l"IP de l"utilisateur

    # Exemple : 
    #
    # UserFileUploadService.new(
    #   user: Current.user,
    #   uploaded_file: params[:file],
    #   category_code: "identity_document",
    #   request_ip: request.remote_ip
    # )
    def initialize(user:, uploaded_file:, category_code:, request_ip: nil)
        @user = user
        @uploaded_file = uploaded_file
        @category_code = category_code
        @request_ip = request_ip
    end

    #   Methode principale appeller par le controller
    # Elle : 
    # - valide le fichier
    # - prepare les chemins
    # - sauvegarde physiquement le fichier'
    # - calcule le SHA256
    # - cree la ligne SQL user_files    
    def call 

        # verifie la presence du fichier sont type et sa taille
        validate_uploaded_file!

        # recherche la category dans la base de donner
        category = FileCategory.find_by!(code: @category_code)

        # nettoie le nom original du fichier
        original_filename = sanitize_original_filename

        # recupere l'extension
        extension = extract_extension(original_filename)

        # Genere un nom unique interne
        stored_filename = generate_stored_filename(extension)

        # Construit le chemin logique du fichier 
        storage_key = build_storage_key(stored_filename)

        # Contruit le vrai chemin physique sur le disque
        full_path = build_full_path(storage_key)

        # Cree automatiquement les dossiers manquants
        FileUtils.mkdir_p(File.dirname(full_path))

        # Sauvegarde le fichier sur le disque
        checksum = write_file_and_calculate_checksum(full_path)

        # Creation de la ligne SQL  dans user_files
        @user.user_files.create!(
            file_category: category,
            original_filename: original_filename,
            stored_filename: stored_filename,
            mime_type: @uploaded_file.content_type,
            file_extension: extension,
            file_size: @uploaded_file.size,
            storage_provider: "local",
            storage_key: storage_key,
            checksum_sha256: checksum,
            is_private: true,
            uploaded_by_ip: @request_ip
        )
    end 

    private

    # Verification : Presence, MIME Type, taille
    def validate_uploaded_file!
        raise ArgumentError, "Aucun fichier fourni." if @uploaded_file.blank?

        unless ALLOWED_MIME_TYPES.include?(@uploaded_file.content_type)
            raise ArgumentError, "Type de fichier non autorisé."
        end

        if @uploaded_file.size > MAX_FILE_SIZE
            raise ArgumentError, "Le fichier est trop volumineux"
        end
    end

    # Nettoie le nom du fichier original pour empecher les chemins dangereux                
    def sanitize_original_filename
        File.basename(@uploaded_file.original_filename.to_s)
    end

    # Retourner l'extension du fichier
    def extract_extension(filename)
        File.extname(filename).delete_prefix(".").downcase
    end

    # Genere un nom unique interne
    # On evite d'utiliser le vrai nom de l'utilisateur
    def generate_stored_filename(extension)
        "#{SecureRandom.uuid}.#{extension}"
    end

    # Construit le chemin logique du fichier
    def build_storage_key(stored_filename)
        "private/users/#{@user.id}/#{@category_code}/#{stored_filename}"
    end

    # Construit le chemin physique reel
    def  build_full_path(storage_key)
        Rails.root.join("storage", storage_key)
    end

     # Sauvegarde physiquement le fichier sur le disque
        #
        # Pendant l'écriture :
        # - on calcule aussi le SHA256
        #
        #  SHA256 : 
        # - vérifier intégrité
        # - détecter doublons
        # - audit sécurité
        #
    def write_file_and_calculate_checksum(full_path)
        # Prepare le calcul SHA256
        digest = Digest::SHA256.new

        # Replace le curseur du fichier au debut
        @uploaded_file.rewind

        # Ouvre le fichier destination en mode ecriture binaire
        File.open(full_path,"wb") do |destination|

            #Lecture par morceau, evite de surcharger la RAM
            while (chunk = @uploaded_file.read(1024 * 1024))
                
                # Ajoute le morceau au SHA256
                digest.update(chunk)

                #Ecri le morceau sur le disque
                destination.write(chunk)
            end
        end

        # Replace le curseur au debut
        @uploaded_file.rewind

        # Retourne le hash SHA256 final 
        digest.hexdigest
    end












end