class UserEmailVerificationToken  < ApplicationRecord
    # Cette vérification appartient à un utilisateur
    belongs_to :user

      # Expose temporairement le token brut en mémoire
  # (jamais sauvegardé en DB)
    attr_reader :raw_token

    # Avant les validations lors de la création,
    # on génère le hash du token et son expiration
    before_validation :generate_token_hash, on: :create
    before_validation :set_expiration, on: :create
    
    validates :token_hash, presence: true, uniqueness: true
    validates  :expires_at, presence:true

    # On fait une requet sur les  tokens qui n'ont pas encore été utilisés
    scope :unused, -> { where(used_at:nil)}


    #une fonction pour savoir si le token est expirer .. 
    def  expired? 
        expires_at <= Time.current
    end

    def used? 
        used_at.present?
    end

    def usable? 
        !used? && !expired?
    end

    private

    def generate_token_hash
        token = SecureRandom.hex(32)

        @raw_token = token
        self.token_hash ||= Digest::SHA256.hexdigest(token)
    end

    def set_expiration
        self.expires_at ||= 5.minutes.from_now
    end
end