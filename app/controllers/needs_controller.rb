class NeedsController < ApplicationController
  def index
    #Nous cherchons directement dans la tables ClientNeed ( select * from ClientNeed avec un join sur domain et location)
    @client_needs = ClientNeed
                    .joins(:client_need_status)
                    .where(client_need_statuses: { code: "open" })
                    .includes(:domain, :service_location_type)
                    .order(is_urgent: :desc, created_at: :desc)
  end

  def show
    #on charge le id dans la table ClientNeed
     @client_need = ClientNeed
                   .joins(:client_need_status)
                   .where(client_need_statuses: { code: "open" })
                   .includes(:domain, :service_location_type, :client_need_items)
                   .find(params[:id])
  end
end
