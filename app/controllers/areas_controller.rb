class AreasController < ApplicationController
  # GET /areas
  # GET /areas.xml
  def index
    @app_search.default 'id', 'asc'

    @app_search.sort 'id', 'areas.id'
    @app_search.sort 'name', 'areas.name'

    @app_search.query = "areas.name like ? "

    alls = Area.all(
#            :include => [],
            :conditions => @app_search.conditions,
#            :conditions => ["areas.name like ? ", @app_search.keyword],
#            :conditions => [@app_search.condition_query] + @app_search.condition_keyword,
#            :conditions => [@app_search.condition_query + " and areas.name = ?"] + @app_search.condition_keyword << 'abc',
            :order => @app_search.orderby
           )
    session_set_ids(alls)
    page = alls.paginate(:page => params[:page], :per_page => PAGINATE_PER_PAGE);
    @areas = page

    xmls = alls

    respond_to do |format|
      format.html # index.html.erb
      format.csv  { send_data(xmls.to_csv(Area), :type => "text/csv") }
#      format.xml  { send_data(xmls.to_xml, :type => "text/xml; charset=utf8;", :disposition => "attachement") }
    end
  end

  # GET /areas/1
  # GET /areas/1.xml
  def show
    @area = Area.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.csv  { send_data(@area.to_a.to_csv(Area), :type => "text/csv") }
#      format.xml  { send_data(@area.to_xml, :type => "text/xml; charset=utf8;", :disposition => "attachement") }
    end
  end

  # GET /areas/new
  # GET /areas/new.xml
  def new
    @area = Area.new(params[:area])
  end

  # GET /areas/1/edit
  def edit
    @area = Area.find(params[:id])
    @area.attributes = params[:area]
  end

  # POST /areas
  # POST /areas.xml
  def check
    @area = Area.new(params[:area])
    render :action => :new, :status => 400 and return unless @area.valid?
  end

  # POST /areas
  # POST /areas.xml
  def create
    begin
      @area = Area.new(params[:area])

      @area.save!

      flash[:notice] = t(:success_created, :id => @area.id)
      redirect_to(areas_url)
    rescue => e
#      flash[:error]  = t(:error_default, :message => e.message)
      render :action => :new
    end
  end

  # PUT /areas/1
  # PUT /areas/1.xml
  def confirm
    @area = Area.find(params[:id])
    @area.attributes = params[:area]
    render :action => :edit, :status => 400 and return unless @area.valid?
  end

  # PUT /areas/1
  # PUT /areas/1.xml
  def update
    begin
      @area = Area.find(params[:id])
      @area.update_attributes(params[:area])

      flash[:notice] = t(:success_updated, :id => @area.id)
      redirect_to(areas_url)
    rescue => e
#      flash[:error]  = t(:error_default, :message => e.message)
      render :action => :edit
    end
  end

  # POST /areas
  # POST /areas.xml
  def upload
    upload_file = ApplicationUpload.new(params[:file])
    upload_msgs = upload_file.import(Area)

    flash[:notice] = t(:success_imported, :msg => upload_msgs) unless upload_msgs.blank?
    redirect_to(areas_url)
  end


  # DELETE /areas/1
  # DELETE /areas/1.xml
  def destroy
    begin
      @area = Area.find(params[:id])
      @area.destroy

Log.create(:user_id => session_get_user, :action => controller_name, :error => action_name + " " + params[:id])

      flash[:notice] = t(:success_deleted, :id => @area.id)
      redirect_to(areas_url)
    rescue => e
      flash[:error] = t(:error_default, :message => e.message)
      render :action => :show
    end
  end
end
