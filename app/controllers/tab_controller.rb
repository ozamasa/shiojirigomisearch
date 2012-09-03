class TabController < ApplicationController
  # GET /tab
  def index
    case params[:tab].to_i
    when 1: redirect_to(xxxs_url)
    end
  end
end
