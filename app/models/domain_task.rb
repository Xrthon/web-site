class DomainTask < ApplicationRecord
    # Il est relier au domain pour preciser ce qu'est la tache dans le domaine
    belongs_to :domain

    has_many :client_need_items, dependent: :restrict_with_exception

    normalizes :code, with: -> (code) { code.strip.downcase}

    validates :code, presence: true, uniqueness: true, length: { maximum: 50 }

    def translated_name
        I18n.t("domain_task.#{code}")
    end 
end 