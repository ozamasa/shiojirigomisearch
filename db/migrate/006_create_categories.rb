class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.string :cycle
      t.text :detail
      t.string :detail_url
      t.text :throw
      t.string :throw_url

      t.integer  :lock_version, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
