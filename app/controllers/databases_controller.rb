class DatabasesController < ApplicationController
  # GET /databases
  # GET /databases.xml
  def list
    @display_type = DISPLAY_TYPE_SIMPLE

    @tables = ActiveRecord::Base.connection.tables

    respond_to do |format|
      format.html # index.html.erb
      format.csv  { send_data(@databases.to_csv, :type => "text/csv") }
#      format.xml  { send_data(xmls.to_xml, :type => "text/xml; charset=utf8;", :disposition => "attachement") }
    end
  end

  # POST /database
  # POST /database.xml
  def import
    table = params[:tablename]
    upload_file = ApplicationUpload.new(params[:file])
    ActiveRecord::Base.connection.execute("update sqlite_sequence set seq=0 where name='" + table + "'")
#    ActiveRecord::Base.connection.execute("alter table " + table + " auto_increment=1")
    ActiveRecord::Base.connection.execute("delete from " + table)
    upload_msgs = upload_file.import_by_sql(table)

    flash[:notice] = t(:success_default) unless upload_msgs.blank?
    redirect_to(:controller => :databases, :action => :index, :tablename=> table)
  end

  # GET /database/xxx
  # GET /database/xxx.xml
  def index
    @display_type = DISPLAY_TYPE_SIMPLE

#    @app_search.default 'id', 'desc'
#    @app_search.sort 'name', 'databases.name'

    @tablename = params[:tablename]
    @columns = ActiveRecord::Base.connection.columns(@tablename)

    where = ""
    unless params[:keyword].blank?
      where = " where"
      @columns.each{|column|
        where += " #{column.name} like '#{@app_search.keyword}' or"
      }
      where = where.slice(0, where.size - 2)
    end

    alls = ActiveRecord::Base.connection.execute("select * from " + @tablename + where)

    session_set_ids(alls)
    session[:prm].delete(:tablename)
    page = alls.paginate(:page => params[:page], :per_page => PAGINATE_PER_PAGE);
    @databases = page

    xmls = alls

    respond_to do |format|
      format.html # index.html.erb
      format.csv  { send_data(xmls.to_csv(:columns => @columns, :table_name => @tablename), :type => "text/csv") }
#      format.xml  { send_data(xmls.to_xml, :type => "text/xml; charset=utf8;", :disposition => "attachement") }
    end
  end

  # GET /databases/new/xxx
  def new
    @display_type = DISPLAY_TYPE_SIMPLE

    @database = set_ar(params).new

    @columns  = ActiveRecord::Base.connection.columns(@tablename)
#   @columns.delete_if {|x| ["id","created_at","updated_at"].include?(x.name) }
  end

  # GET /databases/xxxx/edit/1
  def edit
    @display_type = DISPLAY_TYPE_SIMPLE

    @database = set_ar(params).find(params[:id])

    @columns  = ActiveRecord::Base.connection.columns(@tablename)
#   @columns.delete_if {|x| ["id","created_at","updated_at"].include?(x.name) }
  end

  # POST /databases/xxx
  def create
    @display_type = DISPLAY_TYPE_SIMPLE

    begin
      @database = set_ar(params).new

      @columns  = ActiveRecord::Base.connection.columns(@tablename)
      @columns.delete_if {|x| ["id","created_at","updated_at"].include?(x.name) }
      @columns.each{|column|
        key = column.name
        val = params[column.name]
        @database.update_attributes(key => val)
      }

      flash[:notice] = t(:success_created, :id => @database.id)
      redirect_to(:controller => :databases, :action => :edit, :tablename => @tablename, :id => @database.id)
#      redirect_to(:controller => :databases, :action => :index, :tablename => @tablename)
    rescue => e
      flash[:error]  = t(:error_default, :message => e.message)
      render :action => :new
    end
  end

  # PUT /databases/1
  def update
    @display_type = DISPLAY_TYPE_SIMPLE

    begin
      @database = set_ar(params).find(params[:id])

      @columns  = ActiveRecord::Base.connection.columns(@tablename)
      @columns.delete_if {|x| ["id","created_at","updated_at"].include?(x.name) }
      @columns.each{|column|
        key = column.name
        val = params[column.name]
        @database.update_attributes(key => val)
      }

      flash[:notice] = t(:success_updated, :id => @database.id)
      redirect_to(:controller => :databases, :action => :edit, :tablename => @tablename, :id => @database.id)
    rescue => e
      flash[:error]  = t(:error_default, :message => e.message)
      render :action => :edit
    end
  end

  # DELETE /databases/1
  # DELETE /databases/1.xml
  def destroy
    @display_type = DISPLAY_TYPE_SIMPLE

    begin
      @database = set_ar(params).find(params[:id])

      @database.destroy

      flash[:notice] = t(:success_deleted, :id => @database.id)
      redirect_to(:action => :index)
    rescue => e
      flash[:error] = t(:error_default, :message => e.message)
      render :action => :index
    end
  end


protected
  def set_ar(params)
    @tablename = params[:tablename]
    ar = Class.new(ActiveRecord::Base)
    ar.set_table_name(@tablename)
    return ar
  end
end
