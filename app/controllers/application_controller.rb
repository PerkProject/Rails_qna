require "application_responder"

class ApplicationController < ActionController::Base
  # include Pundit

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { head :forbidden }
      format.js { render json: { error: exception.message }, status: :forbidden }
    end
  end

  private

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to request.headers["Referer"] || root_path
  end
end
