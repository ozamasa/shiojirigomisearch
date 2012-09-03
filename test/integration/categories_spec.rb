require "rubygems"
gem "rspec"
gem "selenium-client"
require "selenium/client"
require "selenium/rspec/spec_helper"
require "spec/test/unit"

def filename(a)
  s = Time.now.strftime("%Y%m%d%H%M%S")
  c = "category"
  p = "#{Dir.pwd}/#{s}_#{c}_#{a}.png"
  return p
end

def click(a, b)
  sleep 1
  page.click a
  page.wait_for_page_to_load "30000"
  sleep 1
  page.capture_entire_page_screenshot filename(b), ""
end

describe "category_spec" do
  attr_reader :selenium_driver
  alias :page :selenium_driver

  before(:all) do
    @verification_errors = []
    @selenium_driver = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => "*chrome",
      :url => "http://localhost:3000/",
      :timeout_in_second => 60
  end

  before(:each) do
    @selenium_driver.start_new_browser_session
  end
  
  append_after(:each) do
    @selenium_driver.close_current_browser_session
    @verification_errors.should == []
  end
  
  it "test_category_spec" do
    page.open "/"
    page.capture_entire_page_screenshot filename("login"), ""

    page.type "id=id", "test"
    page.type "id=password", "test"

    click "css=input[type=\"image\"]", "top"

    click "link=category", "index"

    click "css=img[alt=\"新規作成\"]", "new"

    page.type   "id=category_name", "category_name"
    page.type   "id=category_cycle", "category_cycle"
    page.type   "id=category_detail", "category_detail"
    page.type   "id=category_detail_url", "category_detail_url"
    page.type   "id=category_throw", "category_throw"
    page.type   "id=category_throw_url", "category_throw_url"

    click "css=input[type=\"image\"]", "confirm"

    click "css=input[type=\"image\"]", "create"

    click "link=1", "show"

    click "css=img[alt=\"修正\"]", "edit"

    page.type   "id=category_name", "category_name_after"
    page.type   "id=category_cycle", "category_cycle_after"
    page.type   "id=category_detail", "category_detail_after"
    page.type   "id=category_detail_url", "category_detail_url_after"
    page.type   "id=category_throw", "category_throw_after"
    page.type   "id=category_throw_url", "category_throw_url_after"

    click "css=input[type=\"image\"]", "check"

    click "css=input[type=\"image\"]", "update"

    click "link=category", "index"

#    click "link=1", "show"
#    click "css=img[alt=\"削除\"]"
#    ("削除してもよろしいですか？").should == page.get_confirmation
#    click "link=category", "index"

    page.click "link=ログアウト"
  end
end
