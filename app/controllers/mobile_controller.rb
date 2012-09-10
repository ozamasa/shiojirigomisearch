class MobileController < ApplicationController

  # GET /search
  def search
    begin
      @app_search = ApplicationSearch.new(params)
      @app_search.query = "garbages.name like ? or garbages.ruby like ? or garbages.image_url like ? or categories.name like ? or garbages.note like ? or garbages.gabage_station like ? or garbages.gabage_center like ? or garbages.keyword1 like ? or garbages.keyword2 like ? or garbages.keyword3 like ? or garbages.keyword4 like ? or garbages.keyword5 like ? "

      alls = Garbage.all(
              :include => [:category],
              :conditions => @app_search.conditions
             )
      json = alls.to_json
    rescue
      json = { "error" => true }.to_json
    end

    render_json :json => json
  end

  # GET /garbage
  def garbage
    begin
      garbage = Garbage.find(params[:id])
      json = garbage.to_json
    rescue
      json = { "error" => true }.to_json
    end

    render_json :json => json
  end


  # GET /calendar.ics
  def calendar
    begin
      area = Area.find(params[:area])

      output =<<"EOF"
BEGIN:VCALENDAR
PRODID:-//shiojiri.heroku.com
VERSION:2.0
CALSCALE:GREGORIAN
METHOD:PUBLISH
X-WR-CALNAME:しおじりごみ収集日カレンダー（#{area.name}）
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

      CollectDate.find_all_by_area_id(area.id).each do |collect|
        unless collect.category_group_id.blank?
          output += "BEGIN:VEVENT\r"
          output += "DTSTAMP:" + collect.updated_at.strftime("%Y%m%dT%H%M%SZ")                + "\r"
          output += "DTSTART;VALUE=DATE:" + collect.collect_date.strftime("%Y%m%d")           + "\r"
          output += "DTEND;VALUE=DATE:"   + (collect.collect_date + 1.day).strftime("%Y%m%d") + "\r"

          summ = collect.category_group.name
          desc = collect.category_group.name

          output += "SUMMARY:"     + summ + "\n"
          output += "DESCRIPTION:" + desc + "\n"

          output += "STATUS:CONFIRMED\r"
          output += "TRANSP:TRANSPARENT\r"
          output += "END:VEVENT\r"
        end
      end

      output +=<<"EOF"
END:VCALENDAR
EOF

      send_data(output, :type => "text/calendar; charset=utf-8;")
    rescue
    end
  end

protected
  def authorize
  end

  def render_json(json)
    callback = params[:callback]
    response = begin
      if callback
        "#{callback}(#{json});"
      else
        json
      end
    end
    render({:content_type => :js, :text => response})
  end
end
