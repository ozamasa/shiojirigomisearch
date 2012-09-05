class TabController < ApplicationController
  # GET /tab
  def index
    redirect_to(url_for(:controller => :collect_dates, :action => :index, :area => params[:tab]))
#    case params[:tab].to_i
#    when 1: redirect_to(url_for(:controller => :collect_dates, :action => :index, :area => params[:tab]))
#    end
  end
end
