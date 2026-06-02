#quand on ecrit User --> rails s'attend a trouver la table users dan la BD 
  # ApplicationRecord : herite de ActiveRecord::Base
  # cela donne acces: 
    # SQL
    # .find
    # .where
    # .create
    # Validations
    # callbacks
    # Association 
class User < ApplicationRecord

  # vien du gem bcrypt 
    # Rails rajoute automatiquement :
      # password
      # password=
      #uthenticate()
    # par contre la table SQL doit avoir password_digest
  has_secure_password

  # has_one ruby supprose que user_profile.user_id donc il genere: 
    # user.user_profile
    # user.build_user_profile
    # user.create_user_profile / create_user_profile!(lancve un execption si une erreur de validation)
  has_one :user_profile, dependent: :destroy
  has_one :identity_verification,  class_name: "UserIdentityVerification", dependent: :destroy
 
  # has_many fait en sorte que rails genere automatiquement : 
    #user.user_roles
    #user.user_roles << role
    #user.user_roles.build
    #user.user_roles.build
    #user.user_role_ids
  has_many :user_roles, dependent: :destroy
  has_many :user_files, dependent: :destroy


  # through permet a ruby de faire un join SQL  de users <--> user_roles <-->  roles: 
  has_many :roles, through: :user_roles

  #le destroy permet de supprimer les donner lorsque user.destroy
  has_many :sessions, dependent: :destroy


  #Le controller de user instancie la variable avec le create! du model  UserEmailVerification
  has_many :email_verification_tokens, class_name: "UserEmailVerificationToken", dependent: :destroy

  #
  has_many :password_resets, class_name: "UserPasswordReset", dependent: :destroy

  # s'execute avant la sauvegarde 
  normalizes :email, with: ->(e) { e.strip.downcase }

  # Apres l'insersion SQL Rails appelle ces fonctions
  # after_create :assign_default_role
  # after_create :create_default_profile
  # after_create :create_default_cart

  #validation a faire sur l'email
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def email_verified?
    email_verified_at.present?
  end

  def admin?
    roles.exists?(code: "admin")
  end
  
end