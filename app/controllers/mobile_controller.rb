class MobileController < ApplicationController

  # GET /search
  def search
    begin
      @app_search = ApplicationSearch.new(params)
      @app_search.query = "garbages.name like ? or garbages.ruby like ? or garbages.image_url like ? or categories.name like ? or garbages.note like ? or garbages.gabage_station like ? or garbages.gabage_center like ? or garbages.keyword1 like ? or garbages.keyword2 like ? or garbages.keyword3 like ? or garbages.keyword4 like ? or garbages.keyword5 like ? "

      alls = Garbage.all(
              :include => [:category],
              :conditions => @app_search.conditions,
              :order => "garbages.ruby"
             )

      datas = Array.new
      alls.each{|garbage|
        data = SearchData.new
        data.id = garbage.id
        data.name = garbage.name
        data.ruby = garbage.ruby
        data.image_url = garbage.image_url.blank? ? "" : IMAGE_SERVER + garbage.image_url
        data.keyword1 = garbage.keyword1
        data.keyword2 = garbage.keyword2
        data.keyword3 = garbage.keyword3
        data.keyword4 = garbage.keyword4
        data.keyword5 = garbage.keyword5
        datas << data
      }

      json = datas.to_json
    rescue => e
      json = { :error => true, :discription => e.message }.to_json
    end

    render_json json
  end

  # GET /garbage
  def garbage
    begin
      garbage = Garbage.find(params[:id])

      data = GarbageData.new
      data.id = garbage.id
      data.name = garbage.name
      data.ruby = garbage.ruby
      data.image_url = garbage.image_url.blank? ? "" : IMAGE_SERVER + garbage.image_url
      data.keyword1 = garbage.keyword1
      data.keyword2 = garbage.keyword2
      data.keyword3 = garbage.keyword3
      data.keyword4 = garbage.keyword4
      data.keyword5 = garbage.keyword5

      data.note = garbage.note
      data.gabage_station = garbage.gabage_station
      data.gabage_center = garbage.gabage_center

      unless garbage.category.blank?
        data.category_name = garbage.category.name
        data.category_cycle = garbage.category.cycle
        data.category_detail = garbage.category.detail
        data.category_detail_url = garbage.category.detail_url.blank? ? "" : IMAGE_SERVER + garbage.category.detail_url
        data.category_throw = garbage.category.throw
        data.category_throw_url = garbage.category.throw_url.blank? ? "" : IMAGE_SERVER + garbage.category.throw_url
      end

      begin
        area = Area.find(params[:area].to_i)
        data.area_name = area.name
        collect_date = CollectDate.minimum(
                :collect_date,
                :include => [:area, {:category_group => [:category]}],
                :conditions => ["collect_dates.collect_date >= current_timestamp and collect_dates.area_id = ? and (categories.id = ? and categories.category_group_id = collect_dates.category_group_id)", area.id, garbage.category_id]
               )
        data.collect_date = collect_date.strftime("%m/%d(#{%w(日 月 火 水 木 金 土)[collect_date.wday]})")
# datetime('now', 'localtime')
# current_timestamp
      rescue => e
      end

      json = data.to_json
    rescue => e
      json = { :error => true, :discription => e.message }.to_json
    end

    render_json json
  end

  # GET /garbages/1
  # GET /garbages/1.xml
  def detail
    @display_type = DISPLAY_TYPE_SIMPLE
    @garbage = Garbage.find(params[:id])
  end

  # GET /areas
  def areas
    begin

      alls = Area.all(
              :order => :name
             )

      datas = Array.new
      alls.each{|area|
        data = AreaData.new
        data.id = area.id
        data.name = area.name

        datas << data
      }

      json = datas.to_json
    rescue => e
      json = { :error => true, :discription => e.message }.to_json
    end

    render_json json
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
X-WR-CALNAME:しおじりごみ収集日カレンダー #{area.name}
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

class SearchData
  attr_accessor :id
  attr_accessor :name
  attr_accessor :ruby
  attr_accessor :image_url
  attr_accessor :keyword1
  attr_accessor :keyword2
  attr_accessor :keyword3
  attr_accessor :keyword4
  attr_accessor :keyword5
end

class GarbageData
  attr_accessor :id
  attr_accessor :name
  attr_accessor :ruby
  attr_accessor :image_url
  attr_accessor :keyword1
  attr_accessor :keyword2
  attr_accessor :keyword3
  attr_accessor :keyword4
  attr_accessor :keyword5

  attr_accessor :note
  attr_accessor :gabage_station
  attr_accessor :gabage_center

  attr_accessor :category_name
  attr_accessor :category_cycle
  attr_accessor :category_detail
  attr_accessor :category_detail_url
  attr_accessor :category_throw
  attr_accessor :category_throw_url

  attr_accessor :area_name

  attr_accessor :collect_date

  def initialize
    category_name = ""
    category_cycle = ""
    category_detail = ""
    category_detail_url = ""
    category_throw = ""
    category_throw_url = ""
    area_name = ""
    collect_date = ""
  end
end

class AreaData
  attr_accessor :id
  attr_accessor :name
end
