class CategoriesController < ApplicationController
  # GET /categories
  # GET /categories.xml
  def index
    @app_search.default 'id', 'asc'

    @app_search.sort 'id', 'categories.id'
    @app_search.sort 'name', 'categories.name'
    @app_search.sort 'cycle', 'categories.cycle'
    @app_search.sort 'detail', 'categories.detail'
    @app_search.sort 'detail_url', 'categories.detail_url'
    @app_search.sort 'throw', 'categories.throw'
    @app_search.sort 'throw_url', 'categories.throw_url'

    @app_search.query = "categories.name like ? or categories.cycle like ? or categories.detail like ? or categories.detail_url like ? or categories.throw like ? or categories.throw_url like ? "

    alls = Category.all(
#            :include => [],
            :conditions => @app_search.conditions,
#            :conditions => ["categories.name like ? or categories.cycle like ? or categories.detail like ? or categories.detail_url like ? or categories.throw like ? or categories.throw_url like ? ", @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword],
#            :conditions => [@app_search.condition_query] + @app_search.condition_keyword,
#            :conditions => [@app_search.condition_query + " and categories.name = ?"] + @app_search.condition_keyword << 'abc',
            :order => @app_search.orderby
           )
    session_set_ids(alls)
    page = alls.paginate(:page => params[:page], :per_page => PAGINATE_PER_PAGE);
    @categories = page

    xmls = alls

    respond_to do |format|
      format.html # index.html.erb
      format.csv  { send_data(xmls.to_csv(Category), :type => "text/csv") }
#      format.xml  { send_data(xmls.to_xml, :type => "text/xml; charset=utf8;", :disposition => "attachement") }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.csv  { send_data(@category.to_a.to_csv(Category), :type => "text/csv") }
#      format.xml  { send_data(@category.to_xml, :type => "text/xml; charset=utf8;", :disposition => "attachement") }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new(params[:category])
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    @category.attributes = params[:category]
  end

  # POST /categories
  # POST /categories.xml
  def check
    @category = Category.new(params[:category])
    render :action => :new, :status => 400 and return unless @category.valid?
  end

  # POST /categories
  # POST /categories.xml
  def create
    begin
      @category = Category.new(params[:category])

      @category.save!

      flash[:notice] = t(:success_created, :id => @category.id)
      redirect_to(categories_url)
    rescue => e
      flash[:error]  = t(:error_default, :message => e.message)
      render :action => :new
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def confirm
    @category = Category.find(params[:id])
    @category.attributes = params[:category]
    render :action => :edit, :status => 400 and return unless @category.valid?
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    begin
      @category = Category.find(params[:id])
      @category.update_attributes(params[:category])

      flash[:notice] = t(:success_updated, :id => @category.id)
      redirect_to(categories_url)
    rescue => e
      flash[:error]  = t(:error_default, :message => e.message)
      render :action => :edit
    end
  end

  # POST /categories
  # POST /categories.xml
  def upload
    upload_file = ApplicationUpload.new(params[:file])
    upload_msgs = upload_file.import(Category)

    flash[:notice] = t(:success_imported, :msg => upload_msgs) unless upload_msgs.blank?
    redirect_to(categories_url)
  end


  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    begin
      @category = Category.find(params[:id])
      @category.destroy

Log.create(:user_id => session_get_user, :action => controller_name, :error => action_name + " " + params[:id])

      flash[:notice] = t(:success_deleted, :id => @category.id)
      redirect_to(categories_url)
    rescue => e
      flash[:error] = t(:error_default, :message => e.message)
      render :action => :show
    end
  end
end
