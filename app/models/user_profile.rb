# app/models/user_profile.rb

class UserProfile < ApplicationRecord
  # ===========================================================================
  # RELATIONS
  # ===========================================================================

  # Le profile appartient a un utilisateur
  #
  # Exemple :
  # user_profile.user
  #
  belongs_to :user

  # ===========================================================================
  # VALIDATIONS
  # ===========================================================================

  # Prenom utilisateur
  #
  # Exemple :
  # "John"
  #
  validates :first_name,
            presence: true,
            length: { maximum: 100 }

  # Nom utilisateur
  #
  # Exemple :
  # "Doe"
  #
  validates :last_name,
            presence: true,
            length: { maximum: 100 }

  # Nom affiche publiquement
  #
  # Exemple :
  # "john_doe"
  #
  validates :display_name,
            presence: true,
            length: { maximum: 100 }

  # Numero telephone
  #
  # Exemple :
  # +1 514 555 5555
  #
  validates :phone,
            length: { maximum: 30 },
            allow_blank: true

  # Langue utilisateur
  #
  # Exemple :
  # fr
  # en
  #
  validates :language,
            presence: true,
            length: { maximum: 10 }

  # Timezone utilisateur
  #
  # Exemple :
  # America/Toronto
  #
  validates :timezone,
            length: { maximum: 255 },
            allow_blank: true

  # Pays utilisateur
  #
  validates :country,
            presence: true,
            length: { maximum: 255 }

  # Ville utilisateur
  #
  validates :city,
            presence: true,
            length: { maximum: 255 }

  # Adresse principale
  #
  validates :address_line1,
            presence: true

  # Adresse secondaire
  #
  validates :address_line2,
            allow_blank: true,
            length: { maximum: 1000 }

  # Code postal
  #
  validates :postal_code,
            presence: true,
            length: { maximum: 20 }

  # ===========================================================================
  # NORMALIZATION
  # ===========================================================================

  # Nettoie automatiquement le display name
  #
  # Exemple :
  # " JOHN_DOE "
  #
  # devient :
  # "john_doe"
  #
  normalizes :display_name,
             with: ->(value) { value.strip.downcase }

  # Nettoie automatiquement language
  #
  # Exemple :
  # " FR "
  #
  # devient :
  # "fr"
  #
  normalizes :language,
             with: ->(value) { value.strip.downcase }

  # Nettoie automatiquement le pays
  #
  normalizes :country,
             with: ->(value) { value.strip.titleize }

  # Nettoie automatiquement la ville
  #
  normalizes :city,
             with: ->(value) { value.strip.titleize }

  # ===========================================================================
  # SCOPES
  # ===========================================================================

  # Profiles francais
  #
  # Exemple :
  # UserProfile.french
  #
  scope :french,
        -> { where(language: "fr") }

  # Profiles anglais
  #
  scope :english,
        -> { where(language: "en") }

  # ===========================================================================
  # INSTANCE METHODS
  # ===========================================================================

  # Retourne le nom complet
  #
  # Exemple :
  # "John Doe"
  #
  def full_name
    "#{first_name} #{last_name}"
  end

  # Retourne true si un avatar existe
  #
  # Exemple :
  # user_profile.has_profile_image?
  #
  def has_profile_image?
    profile_image.present?
  end

  # Retourne l'age utilisateur
  #
  # Exemple :
  # 24
  #
  def age
    return nil if birth_date.blank?

    today = Date.current

    age = today.year - birth_date.year

    age -= 1 if birth_date.to_date.change(year: today.year) > today

    age
  end

  # Retourne true si l'utilisateur est majeur
  #
  # Exemple :
  # user_profile.adult?
  #
  def adult?
    age.present? && age >= 18
  end

  # Retourne une adresse complete
  #
  # Exemple :
  # Montreal, Canada
  #
  def location
    "#{city}, #{country}"
  end
end