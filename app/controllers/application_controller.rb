class ApplicationController < ActionController::Base
  ## Prevent CSRF attacks by raising an exception.
  ## For APIs, you may want to use :null_session instead.
  # include ActionController::RequestForgeryProtection::ClassMethods
  # protect_from_forgery with: :exception
  # skip_before_action :verify_authenticity_token

  # a custom module to handle some issues with dates
  include DateFormatter # -- not needed now b/c of gem

  # just show a flash message instead of full CanCan exception
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You are not authorized to take this action.  Go away or I shall taunt you a second time."
    redirect_to home_path
  end

  # handle missing pages the BSG way...
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render template: 'errors/not_found'
  end


  private
  # Handling authentication
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def logged_in?
    current_user
  end
  helper_method :logged_in?

  def check_login
    redirect_to login_url, alert: "You need to log in to view this page." if current_user.nil?
  end

  def flash_codes
    if current_user.email == 'admin@example.com'
      flash[:notice] = "Congratulations! You've hacked the default admin account. Write down the following code so we know you've reached this page: <p align=\"center\"><strong>#{Base64.encode64('hackedadmin')}</strong></p>"
    elsif current_user.email == 'profh@cmu.edu'
      flash[:notice] = "Congratulations! You've hacked Prof. Heimann's account. Write down the following code so we know you've reached this page: <p align=\"center\"><strong>#{Base64.encode64('profh')}</strong></p>"
    elsif current_user.role?(:admin)
      flash[:notice] = "Congratulations! You've promoted an account to admin. Write down the following code so we know you've reached this page: <p align=\"center\"><strong>#{Base64.encode64('promoted')}</strong></p>"
    end
  end
  
end
