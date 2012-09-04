class CreateGarbages < ActiveRecord::Migration
  def self.up
    create_table :garbages do |t|
      t.string :name
      t.string :ruby
      t.string :image_url
      t.references :category
      t.text :note
      t.string :gabage_station
      t.string :gabage_center
      t.string :keyword1
      t.string :keyword2
      t.string :keyword3
      t.string :keyword4
      t.string :keyword5

      t.integer  :lock_version, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :garbages
  end
end
