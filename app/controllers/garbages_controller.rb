class GarbagesController < ApplicationController
  # GET /garbages
  # GET /garbages.xml
  def index
    @app_search.default 'image_url', 'asc'

    @app_search.sort 'id', 'garbages.id'
    @app_search.sort 'name', 'garbages.name'
    @app_search.sort 'ruby', 'garbages.ruby'
    @app_search.sort 'image_url', 'garbages.image_url'
    @app_search.sort 'category', 'categories.name'
    @app_search.sort 'note', 'garbages.note'
    @app_search.sort 'gabage_station', 'garbages.gabage_station'
    @app_search.sort 'gabage_center', 'garbages.gabage_center'
    @app_search.sort 'keyword1', 'garbages.keyword1'
    @app_search.sort 'keyword2', 'garbages.keyword2'
    @app_search.sort 'keyword3', 'garbages.keyword3'
    @app_search.sort 'keyword4', 'garbages.keyword4'
    @app_search.sort 'keyword5', 'garbages.keyword5'

    @app_search.query = "garbages.name like ? or garbages.ruby like ? or garbages.image_url like ? or categories.name like ? or garbages.note like ? or garbages.gabage_station like ? or garbages.gabage_center like ? or garbages.keyword1 like ? or garbages.keyword2 like ? or garbages.keyword3 like ? or garbages.keyword4 like ? or garbages.keyword5 like ? "

    alls = Garbage.all(
            :include => [:category],
            :conditions => @app_search.conditions,
#            :conditions => ["garbages.name like ? or garbages.ruby like ? or garbages.image_url like ? or garbages.category_id like ? or categories.name like ? or garbages.note like ? or garbages.gabage_station like ? or garbages.gabage_center like ? or garbages.keyword1 like ? or garbages.keyword2 like ? or garbages.keyword3 like ? or garbages.keyword4 like ? or garbages.keyword5 like ? ", @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword],
#            :conditions => [@app_search.condition_query] + @app_search.condition_keyword,
#            :conditions => [@app_search.condition_query + " and garbages.name = ?"] + @app_search.condition_keyword << 'abc',
            :order => @app_search.orderby
           )
    session_set_ids(alls)
    page = alls.paginate(:page => params[:page], :per_page => PAGINATE_PER_PAGE);
    @garbages = page

    xmls = alls

    respond_to do |format|
      format.html # index.html.erb
      format.csv  { send_data(xmls.to_csv(Garbage), :type => "text/csv") }
#      format.xml  { send_data(xmls.to_xml, :type => "text/xml; charset=utf8;", :disposition => "attachement") }
    end
  end

  # GET /garbages/1
  # GET /garbages/1.xml
  def show
    @garbage = Garbage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.csv  { send_data(@garbage.to_a.to_csv(Garbage), :type => "text/csv") }
#      format.xml  { send_data(@garbage.to_xml, :type => "text/xml; charset=utf8;", :disposition => "attachement") }
    end
  end

  # GET /garbages/new
  # GET /garbages/new.xml
  def new
    @garbage = Garbage.new(params[:garbage])
  end

  # GET /garbages/1/edit
  def edit
    @garbage = Garbage.find(params[:id])
    @garbage.attributes = params[:garbage]
  end

  # POST /garbages
  # POST /garbages.xml
  def check
    @garbage = Garbage.new(params[:garbage])
    render :action => :new, :status => 400 and return unless @garbage.valid?
  end

  # POST /garbages
  # POST /garbages.xml
  def create
    begin
      @garbage = Garbage.new(params[:garbage])

      @garbage.save!

      flash[:notice] = t(:success_created, :id => @garbage.id)
      redirect_to(garbages_url)
    rescue => e
#      flash[:error]  = t(:error_default, :message => e.message)
      render :action => :new
    end
  end

  # PUT /garbages/1
  # PUT /garbages/1.xml
  def confirm
    @garbage = Garbage.find(params[:id])
    @garbage.attributes = params[:garbage]
    render :action => :edit, :status => 400 and return unless @garbage.valid?
  end

  # PUT /garbages/1
  # PUT /garbages/1.xml
  def update
    begin
      @garbage = Garbage.find(params[:id])
      @garbage.update_attributes(params[:garbage])

      flash[:notice] = t(:success_updated, :id => @garbage.id)
      redirect_to(garbages_url)
    rescue => e
#      flash[:error]  = t(:error_default, :message => e.message)
      render :action => :edit
    end
  end

  # POST /garbages
  # POST /garbages.xml
  def upload
    upload_file = ApplicationUpload.new(params[:file])
    upload_msgs = upload_file.import(Garbage)

    flash[:notice] = t(:success_imported, :msg => upload_msgs) unless upload_msgs.blank?
    redirect_to(garbages_url)
  end


  # DELETE /garbages/1
  # DELETE /garbages/1.xml
  def destroy
    begin
      @garbage = Garbage.find(params[:id])
      @garbage.destroy

Log.create(:user_id => session_get_user, :action => controller_name, :error => action_name + " " + params[:id])

      flash[:notice] = t(:success_deleted, :id => @garbage.id)
      redirect_to(garbages_url)
    rescue => e
      flash[:error] = t(:error_default, :message => e.message)
      render :action => :show
    end
  end
end
