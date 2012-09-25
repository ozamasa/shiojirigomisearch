class AddCountToGarbages < ActiveRecord::Migration
  def self.up
    add_column :garbages, :count, :integer, :default => 0
  end

  def self.down
    remove_column :garbages, :count
  end
end
