require "rubygems"
gem "rspec"
gem "selenium-client"
require "selenium/client"
require "selenium/rspec/spec_helper"
require "spec/test/unit"

def filename(a)
  s = Time.now.strftime("%Y%m%d%H%M%S")
  c = "area"
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

describe "area_spec" do
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
  
  it "test_area_spec" do
    page.open "/"
    page.capture_entire_page_screenshot filename("login"), ""

    page.type "id=id", "test"
    page.type "id=password", "test"

    click "css=input[type=\"image\"]", "top"

    click "link=area", "index"

    click "css=img[alt=\"新規作成\"]", "new"

    page.type   "id=area_name", "area_name"

    click "css=input[type=\"image\"]", "confirm"

    click "css=input[type=\"image\"]", "create"

    click "link=1", "show"

    click "css=img[alt=\"修正\"]", "edit"

    page.type   "id=area_name", "area_name_after"

    click "css=input[type=\"image\"]", "check"

    click "css=input[type=\"image\"]", "update"

    click "link=area", "index"

#    click "link=1", "show"
#    click "css=img[alt=\"削除\"]"
#    ("削除してもよろしいですか？").should == page.get_confirmation
#    click "link=area", "index"

    page.click "link=ログアウト"
  end
end
