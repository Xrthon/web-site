class ClientNeed < ApplicationRecord
    # un besoin client appartien a un user et a un domain 
    belongs_to :user
    belongs_to :domain

    #un besoin client a  un statut, un type de service, une categorie de domaine et un domain
    belongs_to :client_need_status
    belongs_to :service_location_type

    has_many :client_need_items, dependent: :destroy
    accepts_nested_attributes_for :client_need_items

    #avant les validation on me le status par default car c'est pas les clients qui decide
    before_validation :set_default_status, on: :create


    # Validation des champs sql
    validates :title, presence: true, length: { maximum: 255 }
    validates :city, presence: true, length: { maximum: 100 }
    validates :postal_code, presence: true, length: { maximum: 20 }
    validates :province, presence: true, length: { maximum: 100 }

    validates :budget_min, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :budget_max, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :desired_date, presence: true
    validates :is_urgent, inclusion: { in: [true, false] }

    private 

    def set_default_status
        self.client_need_status ||= ClientNeedStatus.find_by(code: 'open')
    end
    

end