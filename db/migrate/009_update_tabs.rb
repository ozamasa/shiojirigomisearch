class UpdateTabs < ActiveRecord::Migration
  def self.up
    begin
      tab = Tab.find(1)
      execute("update tabs set name = '1ブロック' where id = 1")
      execute("update tabs set name = '2ブロック' where id = 2")
      execute("update tabs set name = '3ブロック' where id = 3")
      execute("update tabs set name = '4ブロック' where id = 4")
    rescue
      Tab.create(:name => '1ブロック')
      Tab.create(:name => '2ブロック')
      Tab.create(:name => '3ブロック')
      Tab.create(:name => '4ブロック')
    end
  end

  def self.down
  end
end
