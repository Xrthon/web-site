class Role < ApplicationRecord
  #le meme roole peut etre dans plusieur table 
  has_many :user_roles, dependent: :destroy

  #il peut avoir plusieur utilisateur pour le meme role ppar la table throught  
  has_many :users, through: :user_roles

  validates :code, presence: true, uniqueness: true
end