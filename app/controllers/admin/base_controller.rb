class Admin::BaseController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    return if Current.user&.roles&.exists?(code: "admin")

    redirect_to root_path, alert: "Accès refusé."
  end
end