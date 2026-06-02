class UserPasswordReset < ApplicationRecord

    #Cette verification appartien a l'utilisateur
    belongs_to :user

    #Sauvegarde temporairement le token  
    attr_reader :raw_token

    # avant la validation si on est en mode create: 
    # on genere le token ave la fonction
    # on lui attribu une date d'expiration
    before_validation :generate_token_hash, on: :create
    before_validation :set_expiration, on: :create

    #on valide qu'il a bien un token pour le reset qui est unique
    validates :reset_token_hash, presence: true, uniqueness: true

    # on valide qu'il a bien une date d'expiration
    validates :expires_at, presence: true
    
    # on fait une request dans la bd sur les token non utiliser avec un where pour comparer la validiter du token entrer  
    scope :unused, -> {where(reset_used_at: nil)}

    #  Une fonction pour verifier si il est expirer
    def expired?
        expires_at <= Time.current
    end

    #  Une fonction pour verifier si il est user
    def used?
        reset_used_at.present?
    end

    #  Une fonction pour verifier si il est valide (utilisable)
    def usable? 
        !used? &&  !expired?
    end

    private
    #  Une fonction pour generer un token

    def generate_token_hash
        token = SecureRandom.hex(32)

        @raw_token = token
        self.reset_token_hash ||= Digest::SHA256.hexdigest(token)
    end

    #  Une fonction pour lui attribuer une date d'expiration 
    def set_expiration
        self.expires_at ||= 15.minutes.from_now
    end 
end