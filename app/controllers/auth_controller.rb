class AuthController < ApplicationController
  def login
    unless session_get_user.blank?
      flash[:notice] = ""
      redirect_to(top_url)
      return
    end

    @display_type = DISPLAY_TYPE_SIMPLE

    if request.post?
      begin
        user = User.authenticate(params[:id], params[:password])
        raise if user.blank?
        session_set_user(user)
Log.create(:user_id => user.id, :action => action_name)
        redirect_to(top_url)
      rescue => e
        flash.now[:notice] = t(:error_login)
Log.create(:user_id => 0, :action => action_name, :error => params[:id] + " " + t(:error_login) + " " + e.message)
      end
    end
  end

  def logout
    begin
      user = session[:user_id]
Log.create(:user_id => user.id, :action => action_name) unless user.blank?
    rescue
    end
    session_reset
    redirect_to(root_url)
  end

  def password
    @display_type = DISPLAY_TYPE_SIMPLE
    @user = User.find(session[:user_id])
  end

  def change
    @display_type = DISPLAY_TYPE_SIMPLE

    begin
      @user = User.find(params[:user][:id])
#      redirect_to(:action => :password, :id => @app.user.id) and return unless updated?

      if request.put?
        @user.attributes=params[:user]

        if params[:user][:password] != params[:user][:password_confirmation]
          flash[:notice] = t(:error_pwd_match);
          render :action => :password, :status => 400 and return
        end

        if User.authenticate( @user.account, params[:user][:password_required] ).blank?
          flash[:notice] = t(:error_login)
          render :action => :password, :status => 400 and return
        end

        User.transaction do
          @update_flag = @user.save!
          flash[:notice] = t(:success_updated, :id => @user.name)
        end
      end

    rescue
      render :action => :password, :status => 400 and return
    end
    render :action => :password
  end

  def open_close
    session_set_msg_opn(params[:flag])
    render :text => "" and return
  end

protected
  def authorize
  end
end
