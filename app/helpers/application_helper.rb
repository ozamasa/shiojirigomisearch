# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # 改行⇒<br>
  def hbr(str)
    return if str.blank?
    str = html_escape(str)
    str = hbr_without_escape(str)
  end

  # 改行⇒<br>
  def hbr_without_escape(str)
    return if str.blank?
    str.gsub(/\r\n|\r|\n/, "<br />\n")
  end

  # 名称表示
  def hname(obj)
    unless obj.blank?
      begin
        obj.name_with_id
      rescue
        obj.name
      end
    end
  end

  # 日付表示
  def hdate(obj, options = {})
    format = "%Y/%m/%d" #:default
    format = options[:format] unless options[:format].blank?
    I18n.l obj, :format => format unless obj.blank?
  end

  # 日時表示
  def hdatetime(obj, options = {})
    format = "%Y/%m/%d %H:%M:%S"
    format = options[:format] unless options[:format].blank?
    hdate(obj, :format => format)
  end

  # 金額表示
  def hmoney(obj, options = {})
    number_to_currency obj unless obj.blank?
  end

  # ラベル表示
  def hlabel(obj, method)
    I18n.t(method, :scope => [:activerecord, :attributes, obj])
  end

  # タイトル表示
  def htitle(method)
    I18n.t(method, :scope => [:activerecord, :models])
  end

  # ラジオ表示
  def hradio_openflag(obj, method, value, datas)
    str = ""
    datas.each {|o|
      str += "<label>" + obj.radio_button(method, o.id, {:checked => (o.id == value)}) + o.name_with_id +  "</label>&nbsp;&nbsp;"
    }
    str
  end

  # 年コンボ表示
  def hselect_year(method)
    thisyear = Date.today()
    fromyear = thisyear << 60
    toyear   = thisyear >> 60

    y = Hash.new()
    (fromyear.year..toyear.year).each do |i|
      y[i] = i;
    end
    year = y.sort

    value = params[:selectyear]
    str  = select_tag(:selectyear,  "<option value=''></option>" + options_from_collection_for_select(year,  :first, :last , value.to_i), :onchange => "javascript:submit('#{method}', this.form, 'GET')")
    str += "&nbsp;&nbsp;年&nbsp;&nbsp;"
    str
  end

  # 月コンボ表示
  def hselect_month(method)
    m = Hash.new()
    (1..12).each do |i|
      m[i] = i
    end
    month = m.sort

    value = params[:selectmonth]
    p value
    str  = select_tag(:selectmonth, "<option value=''></option>" + options_from_collection_for_select(month, :first, :last , value.to_i), :onchange => "javascript:submit('#{method}', this.form, 'GET')")
    str += "&nbsp;&nbsp;月&nbsp;&nbsp;"
    str
  end

  # 時間コンボ表示
  def hselect_hour(obj, method, value)
    h = Hash.new()
    (0..23).each do |i|
      h[i] = i
    end
    hour = h.sort

    str  = obj.select method, hour, {:include_blank => true}
    str += " 時"
    str
  end

  # Suggest
  def suggest_field_tag(f, field, model)
    str  = ""
    str += f.text_field field, {:autocomplete => 'off'}
    str += "\n  <div id='#{field}_suggest' class='suggest' style='display:none;'></div>\n"

    list = ""
    model.each_with_index do |c, i|
      list += (i==0 ? "":",") + "\"#{c.name}\""
    end

content_for :head do
concat <<"EOS"
function start_#{field}_suggest() {
var suggest =  new Suggest.Local(
    "#{f.object_name}_#{field}",
    "#{field}_suggest",
    [#{list}],
    {dispMax: 10, highlight: true});
}
window.addEventListener ? window.addEventListener('load', start_#{field}_suggest, false) : window.attachEvent('onload', start_#{field}_suggest);
EOS
end

    return str
  end

  # Ajax
  def remote(controller, action, options = {})
    position = options[:position] unless options[:position].blank?
    with = options[:with] unless options[:with].blank?
    with = "''" if with.blank?
js = <<"EOS"
var with_param = '';
if(obj != null){
  with_param += 'id=' + obj.options[obj.selectedIndex].value;
}
with_param += #{with};
EOS
    js + remote_function(:url => {:controller => controller, :action => action }, :with => "with_param", :update => (controller.to_s + "_" + action.to_s), :position => position)
  end

  # 必須
  def required(options = {})
    " <font color=\"red\">*</font> "
  end

  # 凡例
  def note(text, options = {})
    " [ #{text} ] "
  end

  # ヘッダ
  def header(options = {})
    login_account = @user.account
    login_name    = @user.name
    company       = APP_COMPANY
    link_database = '' # '<li>' + link_to("データベース参照", "javascript:void(0);", :onclick => "javascript:pop('" + url_for(:controller => :databases, :action => :list) + "', '600', 'databasesetting');") + '</li>'
    link_password = '<li>' + link_to("パスワード変更",   "javascript:void(0);", :onclick => "javascript:pop('" + url_for(:controller => :auth, :action => :password ) + "', '600', 'passwordsetting');") + '</li>'
    link_logout   = '<li>' + link_to('ログアウト', :controller => :auth, :action => :logout  ) + '</li>'

    str =<<"EOS"
<div id="header">
<a href="/">
<h1 title="#{APP_TITLE}">#{APP_TITLE}</h1></a>
<div id="hBox">
<h2 id="hCompany">#{company}</h2>
<ul id="hNavi">
#{link_database}
#{link_password}
#{link_logout}
</ul>
<ul id="hUser">
<li>#{login_account} : #{login_name} さん</li>
</ul>
<!--/ #hBox--></div>
<!--/ #header--></div>
EOS
    return str
  end

  # フッタ
  def footer(options = {})
    link_pagetop = link_to 'このページのトップへ', "javascript:pageTop()"

    str =<<"EOS"
<div id ="footer">
<div class="pageTop">#{ link_pagetop }</div>
<!--/ #footer--></div>
EOS
    return str
  end

  # ページタイトル
  def pagetitle(options = {})
    title = options[:title] #TODO

    str =<<"EOS"
<div class="pageTitle">
<h2>#{title}</h2>
</div>
EOS
    return str
  end

  # ページサブタイトル
  def pagesubtitle(options = {})
    title = options[:title] #TODO

    return "<h3>#{title}</h3>"
  end

  # メッセージ
  def message(options = {})
return ""
    js = remote_function(:url => {:controller => :auth, :action => :open_close }, :with => "'flag=' + flag" , :update => "msgBtn")
    jsstr =<<"EOS"
function openclose(){
var flag = showMsg('msgBox','msgBtn');
#{js}
}
EOS

    content_for :head do
      jsstr
    end

    msg = "" if msg.blank?

    (dsp = "block"; cls = "msgMinus")
    (dsp = "none";  cls = "msgPlus")  if session[:msg_opn] == "1"

    str =<<"EOS"
<div id="msgBox" style="display:#{dsp};">
<div id="messageArea">
<div id="messageLeft">
  <div style="width: 100%;">
    <div class="corner">
      <div class="corner1"></div>
      <div class="corner2"></div>
      <div class="corner3"></div>
      <div class="corner4"></div>
    </div>
    <div class="corner5_2">
    <p>
#{msg}
    </p>
    </div>
    <div class="corner">
        <div class="corner4"></div>
        <div class="corner3"></div>
        <div class="corner2"></div>
        <div class="corner1"></div>
    </div>
  </div>
</div>
EOS

  msglist = "" #TODO
  unless msglist.blank?
  str +=<<"EOS"
<div id="messageRight">
  <div style="width: 100%;">
    <div class="corner">
        <div class="corner1"></div>
        <div class="corner2"></div>
        <div class="corner3"></div>
        <div class="corner4"></div>
    </div>
    <div class="corner5">
      <ol>
        #{msglist}
      </ol>
    </div>
    <div class="corner">
      <div class="corner4"></div>
      <div class="corner3"></div>
      <div class="corner2"></div>
      <div class="corner1"></div>
    </div>
  </div>
</div>
EOS
  end

  str +=<<"EOS"
<div id="messageBottom"></div>
<!--/ #messageArea--></div>
</div>
<div style="float: right;">
<a href="#" onClick="openclose('msgBox','msgBtn');blur();"><div id="msgBtn" class="#{cls}"></div></a>
</div>
EOS

#    str = "" if msglist.blank?
    return str
  end

  # メニュー
  def menu(options = {})

    str = "<ul id =\"navi\">\n"
#    str = str + "<li>#{link_to(:top, :controller => :top)}</li>\n"
    str = str + "<li>#{link_to(htitle(:garbage), :controller => :garbages)}</li>\n"
    str = str + "<li>#{link_to(htitle(:collect_date), :controller => :collect_dates)}</li>\n"
    str = str + "<li>#{link_to(htitle(:category), :controller => :categories)}</li>\n"
    str = str + "<li>#{link_to(htitle(:area), :controller => :areas)}</li>\n"
#   str = str + "<li>#{link_to(:top, :controller => :tops)}</li>\n"
    str = str + "</ul>\n"

    return str
  end

  # サブメニュー
  def submenu
      str =<<"EOS"
<div id="sub">
</div>
EOS
    return str
  end

  # タブ
  def tab_tag(tab_id)
    current_path = url_for(:controller => :tab, :action => :index)

    jsstr =<<"EOS"
function change_tab(val){
  ref('#{current_path}?tab=' + val);
}
EOS

    content_for :head do
      jsstr
    end

    str = "<div id=\"tab\"><ul>"
    Tab.all.each{|obj|
      current = ""
      current = "current" if obj.id.to_s == tab_id.to_s
      path = link_to("<span>" + obj.name.to_s + "</span>", "javascript:change_tab('" + obj.id.to_s + "');")
      str += "<li class=\"" + current + "\">" + path + "</li>"
    }

    str += "</ul></div>"

    return str
  end

  # 必須入力メッセージ文言
  def required_notice_tag(options = {})
    " <p>#{required}印のついた項目は、必ず入力してください。</p> "
  end

  # フラッシュ
  def flash_tag
    e = "<div id=\"errorExplanation\" class=\"errorExplanation\"><h2>#{hbr(flash[:error])}</h2></div>" unless flash[:error].blank?
    n = "<div id=\"actionMessage\" class=\"actionMessage\">#{hbr(flash[:notice])}</div>" unless flash[:notice].blank?
    flash.clear
    e.to_s + n.to_s
  end

  # 検索
  def search_tag(options = {})
    text_keyword  = text_field_tag(:keyword, params[:keyword])
    hidden_sort   = hidden_field_tag(:sort,  params[:sort])
    hidden_order  = hidden_field_tag(:order, params[:order])
    other_tag     = options[:other] unless options[:other].blank?
    tab           = tab_tag(options[:tab]) unless options[:tab].blank?

    controller = controller_name
    controller = options[:controller] unless options[:controller].blank?
    action     = :index
    action     = options[:action]     unless options[:action].blank?

    search_form   = 'form_search'
    search_path   = url_for(:controller => controller, :action => action)
    search_button = link_to image_tag('/images/btn_search.png', :alt => '検索', :style => 'vertical-align: middle;'), "javascript:submit('#{search_path}', '#{search_form}', 'GET')"

    str =<<"EOS"
<form name=\"#{search_form}\">
<div style=\"clear: both;\">
#{tab}
</div>
<div style=\"clear: both;\">
#{text_keyword}
#{hidden_sort}
#{hidden_order}
#{search_button}
#{refrech_button_tag}
#{other_tag}
</div>
</form>
EOS
    return str
  end

  # ソート
  def sort_tag(key)
    asc  = ! (!@app_search.blank? && @app_search.tag_sort == key && @app_search.tag_order == 'asc' )
    desc = ! (!@app_search.blank? && @app_search.tag_sort == key && @app_search.tag_order == 'desc')
    sort_asc  = link_to_if asc,  '▲', "javascript:sort('#{key}','asc' );"
    sort_desc = link_to_if desc, '▼', "javascript:sort('#{key}','desc');"
    sort_asc + ' ' + sort_desc
  end

  # 総件数
  def counter_tag(options = {})
    size = options[:size] unless options[:size].blank?
    size = session[:ids].size if options[:size].blank?

    str = <<"EOS"
<div style="float: right;" class="pagination">#{size}件</div>
EOS
  end

  # 一覧ページネートボタン
  def paginate_tag(obj)
    will_paginate obj, :previous_label => "&nbsp;", :next_label => "&nbsp;"
  end

  # 前へ次へボタン
  def prevnext_tag
    ids = session[:ids]
    now = params[:id]
    prv = nxt = nil
    ids.each_with_index{|id,i|
      prv = nxt = nil
      prv = ids[i-1] if (i > 0        && ids[i-1])
      nxt = ids[i+1] if (i < ids.size && ids[i+1])
      break if now.to_s == id.to_s
    }

    params = session[:prm]
    params.delete(:controller)
    params.delete(:action)
    params.delete(:format)

    button_prev  = link_to image_tag('/images/arrow_l.png', :alt => '前へ'),  {:controller => controller_name, :action => action_name, :id => prv} unless prv.blank?
    button_next  = link_to image_tag('/images/arrow_r.png', :alt => '次へ'),  {:controller => controller_name, :action => action_name, :id => nxt} unless nxt.blank?
    button_index = link_to image_tag('/images/tolist.png', :alt => '一覧へ'), {:controller => controller_name, :action => :index, :params => params}

    str =<<"EOS"
<div class="leftBox">
<ul class="prevnxt">
<li class="prevnxt">#{button_prev}</li>
<li class="prevnxt">#{button_index}</li>
<li class="prevnxt">#{button_next}</li>
</ul>
</div>
EOS
  end

  # 新規作成ボタン
  def new_button_tag(options = {})
    params = options[:params]
    link_to image_tag('/images/btn_new.png',    :alt => '新規作成',   :style => 'vertical-align: middle;'), {:controller => controller_name, :action => :new, :params => params}
  end

  # 最新に更新ボタン
  def refrech_button_tag
    link_to image_tag('/images/btn_reload.png', :alt => '最新に更新', :style => 'vertical-align: middle;'), {:controller => controller_name, :action => :index}
  end

  # 修正ボタン
  def edit_button_tag(options = {})
    link_to image_tag('/images/btn_upd.png',    :alt => '修正'                                           ), {:controller => controller_name, :action => :edit, :id => params[:id]}
  end

  # 削除ボタン
  def delete_button_tag(obj, options = {})
    conf = ''
    conf = options[:conf] unless options[:conf].blank?
    conf = '削除してもよろしいですか？' if conf.blank?

    link_to image_tag('/images/btn_delete.png',  :alt => '削除', :style => 'float: right;'), obj, {:controller => controller_name, :confirm => conf, :method => :delete}
  end

  # 一覧ボタン
  def index_button_tag(options = {})
    if action_name == :show.to_s
      params = session[:prm]
      params.delete(:controller)
      params.delete(:action)
      params.delete(:format)
    end

    value = '/images/btn_back.png'       if action_name == :show.to_s
    value = '/images/btn_back.png'       if action_name == :destroy.to_s
    value = '/images/btn_cancel_cre.png' if action_name == :new.to_s
    value = '/images/btn_cancel_cre.png' if action_name == :create.to_s
    value = '/images/btn_cancel_cre.png' if action_name == :check.to_s
    value = '/images/btn_cancel_cre.png' if action_name == :copy.to_s
    value = '/images/btn_cancel_upd.png' if action_name == :edit.to_s
    value = '/images/btn_cancel_upd.png' if action_name == :update.to_s
    value = '/images/btn_cancel_upd.png' if action_name == :confirm.to_s
    value = options[:value]              unless options[:value].blank?
    value = '/images/btn_back.png'       if value.blank?

    action = :index
    action = options[:action]            unless options[:action].blank?

    alt = '一覧へ'
    alt = options[:alt] unless options[:alt].blank?

    link_to image_tag(value, :alt => alt), {:controller => controller_name, :action => action, :params => params}, {:confirm => options[:confirm]}
  end

  # 送信ボタン
  def submit_button_tag(f, options = {})
    value = '/images/btn_create.png'      if action_name == :check.to_s
    value = '/images/btn_update.png'      if action_name == :confirm.to_s
    value = "/images/btn_confirm_cre.png" if action_name == :new.to_s
    value = '/images/btn_confirm_cre.png' if action_name == :create.to_s
    value = '/images/btn_confirm_cre.png' if action_name == :check.to_s && f.error_messages.size > 0
    value = '/images/btn_confirm_cre.png' if action_name == :copy.to_s
    value = '/images/btn_confirm_upd.png' if action_name == :edit.to_s
    value = '/images/btn_confirm_upd.png' if action_name == :update.to_s
    value = '/images/btn_confirm_upd.png' if action_name == :confirm.to_s && f.error_messages.size > 0
    value = options[:value]               unless options[:value].blank?
    value = '/images/btn_update.png'      if value.blank?

    image_submit_tag value, :confirm => options[:confirm], :onclick => options[:onclick]
  end

  # ポップ
  def pop_button_tag(path, size, elm, type, options = {})
    link_to("検索", "javascript:popSearch('" + path + "','" + size.to_s + "','" + elm + "','','" + type + "');")
  end

  # 検索ポップアップ
  def pop_search_tag(elm, type)
    pop_button_tag('/search', 750, elm, type)
  end

  # 戻るボタン
  def back_button_tag(options = {})
    value = '/images/btn_reenter.png'
    value = options[:value] unless options[:value].blank?

    action = :new  if action_name == :check.to_s
    action = :edit if action_name == :confirm.to_s
    path = url_for(:controller => controller_name, :action => action, :id => params[:id])

    link_to image_tag(value), "javascript:submit('#{path}')", {:confirm => options[:confirm]}
  end

  # トップへ戻るボタン
  def top_button_tag(options = {})
    value = '/images/btn_back.png'
    alt = '戻る'
    alt = options[:alt] unless options[:alt].blank?
    link_to image_tag(value, :alt => alt), {:controller => :top, :action => :index}
  end

  # CSV出力ボタン
  def csv_button_tag(options = {})
    out = false
    return unless options[:out].blank?
    style = 'vertical-align: middle;'
    style = '' if action_name == :show.to_s
    url = url_for(params.merge(params))
    url = url_for(params.merge(:format => :csv))
    link_to image_tag('/images/btn_csv.png', :alt => 'CSV出力', :style => style), url, {:confirm => 'CSVを出力しますか？', :target => '_blank'}
  end

  # コピーボタン
  def copy_button_tag(options = {})
    value = '/images/btn_copy.png'
    value = options[:value] unless options[:value].blank?
    alt = '流用作成'
    alt = options[:alt] unless options[:alt].blank?
    controller = controller_name
    controller = options[:controller] unless options[:controller].blank?
    action = :copy
    action = options[:action] unless options[:action].blank?
    path = url_for(:controller => controller, :action => action)
    link_to image_tag(value, :alt => alt), "javascript:submit('#{path}')"
  end

  # クリアボタン
  def clear_button_tag(options = {})
    # link_to image_tag('/images/btn_clear.png', :alt => 'クリア'), {:confirm => options[:confirm]}
  end

  # 閉じるボタン
  def close_button_tag(options = {})
    link_to image_tag('/images/btn_close.png', :alt => '閉じる'), "javascript:windowClose()"
  end

  # カレンダー選択値クリアボタン
  def clear_cal_button_tag(options = {})
    button_to_function("クリア", "showCalClearBtn(this)", :class => "clearCalBtn")
  end

end
