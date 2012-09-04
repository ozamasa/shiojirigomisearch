class TopController < ApplicationController
  def index
    redirect_to(garbages_url)
  end
end
