class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound, with: :error_not_found
  rescue_from Pundit::NotAuthorizedError, with: :error_not_authorized

  def error_not_found
    render "/application/errors/404", status: :not_found, formats: [ :html ]
  end

  private

  def error_not_authorized
    redirect_to root_path, alert: "У вас нет доступа к этому ресурсу."
  end
end
