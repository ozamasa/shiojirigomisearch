class CreateCollectDates < ActiveRecord::Migration
  def self.up
    create_table :collect_dates do |t|
      t.references :area
      t.references :category
      t.date :collect_date

      t.integer  :lock_version, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :collect_dates
  end
end
