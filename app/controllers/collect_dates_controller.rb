class CollectDatesController < ApplicationController
  # GET /collect_dates
  # GET /collect_dates.xml
  def index
    @app_search.default 'collect_date', 'asc'

#    @app_search.sort 'id', 'collect_dates.id'
#    @app_search.sort 'area', 'areas.name'
#    @app_search.sort 'category', 'categories.name'
    @app_search.sort 'collect_date', 'collect_dates.collect_date'

    @area_id = params[:area].blank? ? "1" : params[:area]
    @area = Area.find(@area_id)

    @cy = params[:y].blank? ? Time.now.year  : params[:y].to_i
    @cm = params[:m].blank? ? Time.now.month : params[:m].to_i

    @pm = ((@cm - 1) == 0) ? 12 : (@cm - 1)
    @py = (@pm == 12) ? (@cy - 1) : @cy

    @nm = (@cm == 12) ? 1 : (@cm + 1)
    @ny = (@nm == 1) ? (@cy + 1) : @cy

    @cm = @cm.to_i < 10 ? "0" + @cm.to_s : @cm.to_s
    @pm = @pm.to_i < 10 ? "0" + @pm.to_s : @pm.to_s
    @nm = @nm.to_i < 10 ? "0" + @nm.to_s : @nm.to_s

    require 'date'
    @first_date = Date::new(@cy.to_i, @cm.to_i, 1)

#    @app_search.query = "areas.name like ? or categories.name like ? "

    alls = CollectDate.all(
            :include => [:area, :category], 
            :conditions => ["areas.id = ? and to_char(collect_date, 'yyyyMM') = ?", @area_id, "#{@cy}#{@cm}"],
# strftime('%Y%m', collect_date)
#            :conditions => @app_search.conditions,
#            :conditions => ["collect_dates.area_id like ? or areas.name like ? or collect_dates.category_id like ? or categories.name like ? or collect_dates.collect_date like ? ", @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword, @app_search.keyword],
#            :conditions => [@app_search.condition_query] + @app_search.condition_keyword,
            :order => @app_search.orderby
           )
#    session_set_ids(alls)
#    page = alls.paginate(:page => params[:page], :per_page => PAGINATE_PER_PAGE);
#    @collect_dates = page
    @collect_dates = alls

    xmls = alls

    respond_to do |format|
      format.html # index.html.erb
      format.csv  { send_data(xmls.to_csv(CollectDate), :type => "text/csv") }
#      format.xml  { send_data(xmls.to_xml, :type => "text/xml; charset=utf8;", :disposition => "attachement") }
    end
  end

  # GET /collect_dates/1
  # GET /collect_dates/1.xml
  def show
    @collect_date = CollectDate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.csv  { send_data(@collect_date.to_a.to_csv(CollectDate), :type => "text/csv") }
#      format.xml  { send_data(@collect_date.to_xml, :type => "text/xml; charset=utf8;", :disposition => "attachement") }
    end
  end

  # GET /collect_dates/new
  # GET /collect_dates/new.xml
  def new
    @collect_date = CollectDate.new(params[:collect_date])
  end

  # GET /collect_dates/1/edit
  def edit
    @collect_date = CollectDate.find(params[:id])
    @collect_date.attributes = params[:collect_date]
  end

  # POST /collect_dates
  # POST /collect_dates.xml
  def check
    @collect_date = CollectDate.new(params[:collect_date])
    render :action => :new, :status => 400 and return unless @collect_date.valid?
  end

  # POST /collect_dates
  # POST /collect_dates.xml
  def create
    begin
      @collect_date = CollectDate.new(params[:collect_date])

      @collect_date.save!

      flash[:notice] = t(:success_created, :id => @collect_date.id)
      redirect_to(collect_dates_url)
    rescue => e
      flash[:error]  = t(:error_default, :message => e.message)
      render :action => :new
    end
  end

  # PUT /collect_dates/1
  # PUT /collect_dates/1.xml
  def confirm
    @collect_date = CollectDate.find(params[:id])
    @collect_date.attributes = params[:collect_date]
    render :action => :edit, :status => 400 and return unless @collect_date.valid?
  end

  # PUT /collect_dates/1
  # PUT /collect_dates/1.xml
  def update
    begin
      @collect_date = CollectDate.find(params[:id])
      @collect_date.update_attributes(params[:collect_date])

      flash[:notice] = t(:success_updated, :id => @collect_date.id)
      redirect_to(collect_dates_url)
    rescue => e
      flash[:error]  = t(:error_default, :message => e.message)
      render :action => :edit
    end
  end

  # POST /collect_dates
  # POST /collect_dates.xml
  def upload
    upload_file = ApplicationUpload.new(params[:file])
    upload_msgs = upload_file.import(CollectDate)

    flash[:notice] = t(:success_imported, :msg => upload_msgs) unless upload_msgs.blank?
    redirect_to(collect_dates_url)
  end


  # DELETE /collect_dates/1
  # DELETE /collect_dates/1.xml
  def destroy
    begin
      @collect_date = CollectDate.find(params[:id])
      @collect_date.destroy

Log.create(:user_id => session_get_user, :action => controller_name, :error => action_name + " " + params[:id])

      flash[:notice] = t(:success_deleted, :id => @collect_date.id)
      redirect_to(collect_dates_url)
    rescue => e
      flash[:error] = t(:error_default, :message => e.message)
      render :action => :show
    end
  end


  # GET /collect_dates
  # GET /collect_dates.ics
  def calendar
    output =<<"EOF"
BEGIN:VCALENDAR
PRODID:-//shiojiri.heroku.com
VERSION:2.0
CALSCALE:GREGORIAN
METHOD:PUBLISH
X-WR-CALNAME:収集日カレンダー
X-WR-TIMEZONE:Asia/Tokyo
BEGIN:VTIMEZONE
TZID:Asia/Tokyo
X-LIC-LOCATION:Asia/Tokyo
BEGIN:STANDARD
TZOFFSETFROM:+0900
TZOFFSETTO:+0900
TZNAME:JST
DTSTART:19700101T000000
END:STANDARD
END:VTIMEZONE
EOF

    CollectDate.all.each do |collect|
      output += "BEGIN:VEVENT\r"
      output += "DTSTAMP:" + collect.updated_at.strftime("%Y%m%dT%H%M%SZ")                + "\r"
      output += "DTSTART;VALUE=DATE:" + collect.collect_date.strftime("%Y%m%d")           + "\r"
      output += "DTEND;VALUE=DATE:"   + (collect.collect_date + 1.day).strftime("%Y%m%d") + "\r"

      summ = collect.category.name
      desc = collect.category.name

      output += "SUMMARY:"     + summ + "\n"
      output += "DESCRIPTION:" + desc + "\n"

      output += "STATUS:CONFIRMED\r"
      output += "TRANSP:TRANSPARENT\r"
      output += "END:VEVENT\r"
    end

    output +=<<"EOF"
END:VCALENDAR
EOF

    respond_to do |format|
      format.ics  {send_data(output, :type => "text/calendar; charset=utf-8;") }
    end
  end

end
