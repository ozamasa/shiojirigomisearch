class InsertCollectDates < ActiveRecord::Migration
  def self.up
    require 'date'

    CollectDate.delete_all

    s_date = Date::new(2012, 4, 1)
    e_date = Date::new(2014, 3, 31)
    (s_date..e_date).each do |day|
      begin
        CollectDate.create(:area_id => 1, :collect_date => day)
        CollectDate.create(:area_id => 2, :collect_date => day)
        CollectDate.create(:area_id => 3, :collect_date => day)
        CollectDate.create(:area_id => 4, :collect_date => day)
      rescue
      end
    end
  end

  def self.down
  end
end
