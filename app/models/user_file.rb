
# app/models/user_file.rb

class UserFile < ApplicationRecord
  # ===========================================================================
  # RELATIONS
  # ===========================================================================

  # Le fichier appartient a un utilisateur
  #
  # Exemple :
  # user_file.user
  #
  belongs_to :user

  # Le fichier appartient a une categorie
  #
  # Exemple :
  # profile_image
  # identity_document
  # invoice
  #
  belongs_to :file_category

  # ===========================================================================
  # VALIDATIONS
  # ===========================================================================

  # Nom original du fichier fourni par l'utilisateur
  #
  # Exemple :
  # "passport.png"
  #
  validates :original_filename,
            presence: true,
            length: { maximum: 255 }

  # Nom interne genere par le systeme
  #
  # Exemple :
  # "8f92f0f1-acde-4122.webp"
  #
  validates :stored_filename,
            presence: true,
            length: { maximum: 255 }

  # Type MIME du fichier
  #
  # Exemple :
  # image/png
  # application/pdf
  #
  validates :mime_type,
            presence: true,
            length: { maximum: 100 }

  # Extension du fichier
  #
  # Exemple :
  # png
  # pdf
  #
  validates :file_extension,
            length: { maximum: 20 },
            allow_blank: true

  # Taille du fichier en bytes
  #
  # Exemple :
  # 1048576
  #
  validates :file_size,
            presence: true,
            numericality: {
              greater_than: 0
            }

  # Provider de stockage
  #
  # Exemple :
  # local
  # s3
  # cloudflare_r2
  #
  validates :storage_provider,
            presence: true,
            length: { maximum: 50 }

  # Cle du fichier dans le systeme de stockage
  #
  # Exemple :
  # users/15/profile/avatar.webp
  #
  validates :storage_key,
            presence: true

  # Hash SHA256 du fichier
  #
  # Sert a :
  # - verifier integrite
  # - detecter doublons
  # - audit securite
  #
  validates :checksum_sha256,
            length: { is: 64 },
            allow_blank: true

  # Adresse IP du upload
  #
  # Compatible IPv4 / IPv6
  #
  validates :uploaded_by_ip,
            length: { maximum: 45 },
            allow_blank: true

  # ===========================================================================
  # NORMALIZATION
  # ===========================================================================

  # Nettoie automatiquement le mime type
  #
  # Exemple :
  # " IMAGE/PNG "
  #
  # devient :
  # "image/png"
  #
  normalizes :mime_type,
             with: ->(value) { value.strip.downcase }

  # Nettoie automatiquement l'extension
  #
  # Exemple :
  # ".PNG"
  #
  # devient :
  # "png"
  #
  normalizes :file_extension,
             with: ->(value) do
               value.strip.downcase.delete_prefix(".")
             end

  # Nettoie automatiquement le provider
  #
  # Exemple :
  # " LOCAL "
  #
  # devient :
  # "local"
  #
  normalizes :storage_provider,
             with: ->(value) { value.strip.downcase }

  # ===========================================================================
  # SCOPES
  # ===========================================================================

  # Retourne uniquement les fichiers prives
  #
  # Exemple :
  # UserFile.private_files
  #
  scope :private_files,
        -> { where(is_private: true) }

  # Retourne uniquement les fichiers publics
  #
  # Exemple :
  # UserFile.public_files
  #
  scope :public_files,
        -> { where(is_private: false) }

  # Retourne les images uniquement
  #
  # Exemple :
  # UserFile.images
  #
  scope :images,
        -> { where("mime_type like ?", "image/%") }

  # ===========================================================================
  # INSTANCE METHODS
  # ===========================================================================

  # Verifie si le fichier est prive
  #
  # Exemple :
  # user_file.private?
  #
  def private?
    is_private
  end

  # Retourne le nom complet du fichier
  #
  # Exemple :
  # avatar.png
  #
  def full_filename
    stored_filename
  end

  # Retourne la taille du fichier en MB
  #
  # Exemple :
  # 5.24
  #
  def file_size_in_mb
    (file_size.to_f / 1024 / 1024).round(2)
  end

  # Retourne true si le fichier est une image
  #
  # Exemple :
  # user_file.image?
  #
  def image?
    mime_type.start_with?("image/")
  end

  # Retourne true si le fichier est un PDF
  #
  # Exemple :
  # user_file.pdf?
  #
  def pdf?
    mime_type == "application/pdf"
  end

  # Retourne le chemin complet du fichier
  #
  # Exemple :
  # users/15/profile/avatar.webp
  #
  def storage_path
    storage_key
  end
end
