class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  protect_from_forgery with: :exception
  before_action :current_user
  before_action :current_group
  before_action :session_expiry

  def current_user
    @current_user ||= User.find_by(id:session[:user_id]) if session[:user_id]
    Current.user = @current_user
    @current_user
  end
  helper_method :current_user

  def current_group
    @current_group ||= Group.find_by(id:session[:group_id]) if session[:group_id]
    Current.group = @current_group 
    if @current_group.present? 
      Current.club = @current_group.club
    end
    @current_group
  end
  helper_method :current_group

  def require_login
    if current_user.nil? 
      redirect_to root_url, alert: "I'm sorry. I can't do that."
    end
  end
  helper_method :require_login

  def require_super
    unless current_user && current_user.is_super? 
      redirect_to root_url, alert: "I'm sorry. I can't do that."
    end
  end
  helper_method :require_super

  def is_manager?
    current_user && current_user.is_manager?
  end
  helper_method :is_manager?

  def is_super?
    current_user && current_user.is_super?
  end
  helper_method :is_super?

  def is_coordinator?
    current_user && current_user.is_coordinator?
  end
  helper_method :is_coordinator?


  def cant_do_that(msg=nil)
    redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that. #{msg}"
  end
  helper_method :cant_do_that

  def session_expiry
    if current_user.present? && session[:expires_at].present?
      get_session_time_left
      unless @session_time_left > 0
        if @current_user.present?
          # sign_out and redirect for new login
          sign_out
          deny_access 'Your session has timed out. Please log back in.'
        else
          # just kill session and start a new one
          sign_out
        end
      end
    else
      # expire all sessions, even if not user to 30 minutes
      session[:expires_at] = Time.now + 30.minutes
    end
  end

  def get_session_time_left
    expire_time = Time.parse(session[:expires_at]) || Time.now
    @session_time_left = (expire_time - Time.now).to_i
    @expires_at = expire_time.strftime("%I:%M:%S%p")
  end
 
end
