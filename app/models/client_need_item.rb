class ClientNeedItem < ApplicationRecord

    # L'element du besoin client appartient a un besoin client
    # et a une tache dans un domaine
    belongs_to :client_need
    belongs_to :domain_task

    validates :description, length: { maximum: 1000 }, allow_blank: true
    validates :quantity, numericality: { greater_than_or_equal_to: 0 }

end 