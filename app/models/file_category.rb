# app/models/file_category.rb

class FileCategory < ApplicationRecord
  # ---------------------------------------------------------------------------
  # Relations
  # ---------------------------------------------------------------------------

  # Une categorie peut etre utilisee par plusieurs fichiers
  #
  # Exemple :
  # - profile_image
  # - identity_document
  # - invoice
  #
  has_many :user_files, dependent: :restrict_with_error

  # ---------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------

  # Le code est obligatoire
  #
  # Exemple :
  # "profile_image"
  #
  validates :code,
            presence: true,
            uniqueness: true,
            length: { maximum: 50 }

  # ---------------------------------------------------------------------------
  # Normalization
  # ---------------------------------------------------------------------------

  # Nettoie automatiquement le code avant sauvegarde
  #
  # Exemple :
  # " PROFILE_IMAGE "
  #
  # devient :
  # "profile_image"
  #
  normalizes :code,
             with: ->(code) { code.strip.downcase }

  # ---------------------------------------------------------------------------
  # Instance Methods
  # ---------------------------------------------------------------------------

  # Permet de traduire la categorie avec I18n
  #
  # Exemple :
  # file_category.translated_name
  #
  # Retour :
  # "image de profil"
  #
  def translated_name
    I18n.t("file_categories.#{code}")
  end
end