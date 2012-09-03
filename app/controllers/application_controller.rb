# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  require 'active_record_helper'
  require 'action_view_helper'
  require 'active_support_csv'

  before_filter :authorize

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

#  rescue_from Exception, :with => :error

protected
  def error(e)
    logger.error(e.message);
    flash[:error] = t(:error_default, :message => e)
    begin
      if action_name == :index.to_s
        reset_session
        redirect_to(login_url)
        return
      end
      redirect_to(:action => :index)
    rescue
      redirect_to(top_url)
    end
  end

  def authorize
    begin
      session_check
      @user = User.find(session_get_user)
      raise unless @user
      @app_search = ApplicationSearch.new(params) if action_name == :index.to_s
    rescue => e
      logger.debug(e.message)
      flash[:notice] = t(:error_authorize)
      redirect_to(root_url)
    end
  end

  def session_reset
    session[:user_id] = nil
    session[:ids]     = nil
    session[:prm]     = nil
    session[:msg_opn] = nil
    reset_session
  end

  def session_check
    raise unless session[:user_id]
  end

  def session_get_user
    return session[:user_id]
  end

  def session_get_ids
    return session[:ids]
  end

  def session_get_prm
    return session[:prm]
  end

  def session_get_msg_opn
    return session[:msg_opn]
  end

  def session_set_user(user)
    session[:user_id] = user.id
  end

  def session_set_ids(objs)
#    return unless params[:format].to_s == :html.to_s
    ids = Array.new(objs.size)
    session[:ids] = ids
    session[:prm] = params
  end

  def session_set_msg_opn(msg_opn)
    session[:msg_opn] = msg_opn
  end

end
