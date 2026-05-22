class User < ApplicationRecord
  has_secure_password

  #cette table possede un foreigne key de role
  belongs_to :role, optional:true 

  has_one :user_profile, dependent: :destroy
  # ici on pourrais forcer l'utilisateur a avoir un seul panier avec : has_one :cart
  
  has_many :sessions, dependent: :destroy
  #Par contre il est plus que courrant de vcouloir plusieur panier exemple avec des wishlist etc...
  has_many :carts, dependent: :destroy
  
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_create :assign_default_role
  after_create :create_default_profile    
  after_create :create_default_cart

  private

  def assign_default_role 
    update(role: Role.find_by!(name: "client"))
  end

  def create_default_profile
    create_user_profile!
  end

  def create_default_cart
    carts.create!(status: "active")
  end

  def active_cart
    carts.find_by(status: "active")
  end
end
