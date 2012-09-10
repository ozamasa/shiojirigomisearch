class CreateCategoryGroups < ActiveRecord::Migration
  def self.up
    create_table :category_groups do |t|
      t.string :name

      t.integer  :lock_version, :null => false, :default => 0
      t.timestamps
    end

    CategoryGroup.create(:name => 'プラスチック製容器包装')
    CategoryGroup.create(:name => '紙類・ペットボトル')
    CategoryGroup.create(:name => '缶類・びん類・布類')
    CategoryGroup.create(:name => 'その他金属')
    CategoryGroup.create(:name => 'せん定木・落ち葉')
    CategoryGroup.create(:name => 'てんぷら油')
    CategoryGroup.create(:name => 'もえるごみ')
    CategoryGroup.create(:name => 'うめたてごみ')
    CategoryGroup.create(:name => '有害物')

    add_column :categories, :category_group_id, :int
    rename_column :collect_dates, :category_id, :category_group_id
  end

  def self.down
    drop_table :category_groups
    remove_column :categories, :category_group_id
    rename_column :collect_dates, :category_group_id, :category_id
  end
end
