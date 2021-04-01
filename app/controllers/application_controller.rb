# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :exception
  class Forbidden < ActionController::ActionControllerError
  end

  rescue_from Exception, with: :render_500
  rescue_from Forbidden, with: :render_403
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  def render_403(e)
    @exception = e
    render template: 'errors/error_403', status: 403
  end

  def render_404(e)
    @exception = e
    render template: 'errors/error_404', status: 404
  end

  def render_500(e)
    @exception = e
    render template: 'errors/error_500', status: 500
  end
end
